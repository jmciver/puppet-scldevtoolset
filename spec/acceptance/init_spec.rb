require 'spec_helper_acceptance'

describe 'scldevtoolset class' do
  context 'versions = default' do
    it 'verify idempotency' do
      pp = <<-EOS
        include scldevtoolset
      EOS

      # Run Puppet agent twice and test for idempotency.
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe package('devtoolset-8') do
      it { is_expected.to be_installed }
    end

    [7, 9].each do |version|
      describe package("devtoolset-#{version}") do
        it { is_expected.not_to be_installed }
      end
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

    [9].each do |version|
      describe package("devtoolset-#{version}") do
        it { is_expected.not_to be_installed }
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

    [7, 8].each do |version|
      describe package("devtoolset-#{version}") do
        it { is_expected.not_to be_installed }
      end
    end
  end
end
