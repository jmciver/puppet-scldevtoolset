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

    Array(3..7).each do |version|
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

    Array(7..8).each do |version|
      describe package("devtoolset-#{version}") do
        it { is_expected.to be_installed }
      end
    end

    Array(3..6).each do |version|
      describe package("devtoolset-#{version}") do
        it { is_expected.not_to be_installed }
      end
    end
  end

  context 'versions = [6, 8]' do
    it 'verify version install and removal' do
      pp1 = <<-EOS
        class { 'scldevtoolset':
          versions => [7, 8]
        }
      EOS

      pp2 = <<-EOS
        class { 'scldevtoolset':
          versions => [6, 8]
        }
      EOS

      apply_manifest(pp1, catch_failures: true)
      apply_manifest(pp2, catch_failures: true)
    end

    [6, 8].each do |version|
      describe package("devtoolset-#{version}") do
        it { is_expected.to be_installed }
      end
    end

    [3, 4, 5, 7].each do |version|
      describe package("devtoolset-#{version}") do
        it { is_expected.not_to be_installed }
      end
    end
  end
end
