require 'spec_helper_acceptance'

describe 'scldevtoolset class' do
  context 'versions argument is not specified' do
    it 'verify idempotency' do
      pp = <<-EOS
        include scldevtoolset
      EOS

      # Run Puppet agent twice and test for idempotency.
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe package('devtoolset-9') do
      it { is_expected.to be_installed }
    end
  end

  context 'versions = [7, 8]' do
    it 'verify multiple version install' do
      pp = <<-EOS
        class { 'scldevtoolset':
          versions => [7, 8]
        }
      EOS

      apply_manifest(pp, catch_failures: true)
    end

    [7, 8].each do |version|
      describe package("devtoolset-#{version}") do
        it { is_expected.to be_installed }
      end
    end
  end

  context 'versions = [9]' do
    it 'verify single version install' do
      pp = <<-EOS
        class { 'scldevtoolset':
          versions => [9]
        }
      EOS

      apply_manifest(pp, catch_failures: true)
    end

    [9].each do |version|
      describe package("devtoolset-#{version}") do
        it { is_expected.to be_installed }
      end
    end
  end

  context 'versions = [7, 8, 9] with environment modules' do
    let(:module_path) { '/etc/modulefiles/scl-devtools' }

    it 'verify multiple version install' do
      pp = <<-EOS
        class { 'scldevtoolset':
          versions                => [7, 8, 9],
          use_modules             => true,
          install_modules_package => true,
        }
      EOS

      apply_manifest(pp, catch_failures: true)
    end

    it 'install directory /etc/modulefiles/scl-devtools' do
      expect(shell('[ -d /etc/modulefiles/scl-devtools ];').exit_code).to eq 0
    end

    it 'install file /etc/modulefiles/scl-devtools/.base' do
      expect(shell('[ -f /etc/modulefiles/scl-devtools/.base ];').exit_code).to eq 0
    end

    [7, 8, 9].each do |version|
      it "install symlink /etc/modulefiles/scl-devtools/#{version} to /etc/modulefiles/scl-devtools/.base" do
        expect(
          shell(
            "[ -h /etc/modulefiles/scl-devtools/#{version} ] && [ $(readlink /etc/modulefiles/scl-devtools/#{version}) = '/etc/modulefiles/scl-devtools/.base' ];",
          ).exit_code,
        ).to eq 0
      end

      it "module load devtools-#{version}" do
        expect(
          shell(
            "module load scl-devtools/#{version}; gcc --version | head -n 1 |  cut -d \" \" -f3 | cut -d \".\" -f1;",
          ).stdout.strip,
        ).to eq version.to_s
      end

      describe package("devtoolset-#{version}") do
        it { is_expected.to be_installed }
      end
    end
  end

  context 'versions = [9] with environment modules' do
    it 'verify multiple version install' do
      pp = <<-EOS
        package { 'environment-modules':
          ensure => present,
        }

        class { 'scldevtoolset':
          versions                => [7, 8, 9],
          use_modules             => true,
          install_modules_package => false,
          require                 => Package['environment-modules'],
        }
      EOS

      apply_manifest(pp, catch_failures: true)
    end
  end
end
