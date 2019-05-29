require 'spec_helper'

describe 'scldevtoolset' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'version parameter is not specified' do
        it { is_expected.to compile }
        it { is_expected.to compile.with_all_deps }
        it {
          is_expected.to contain_package('centos-release-scl')
            .with_ensure('present')
            .that_comes_before(['Package[devtoolset-8]'])
        }
        it { is_expected.to contain_package('devtoolset-8').only_with_ensure('present') }
        Array(3..7).each do |version|
          it { is_expected.to contain_package("devtoolset-#{version}").only_with_ensure('absent') }
        end
      end

      context 'version = [8]' do
        let(:params) { { 'versions' => [8] } }

        it { is_expected.to compile }
        it { is_expected.to compile.with_all_deps }
        it {
          is_expected.to contain_package('centos-release-scl')
            .with_ensure('present')
            .that_comes_before(['Package[devtoolset-8]'])
        }
        it { is_expected.to contain_package('devtoolset-8').only_with_ensure('present') }
        Array(3..7).each do |version|
          it { is_expected.to contain_package("devtoolset-#{version}").only_with_ensure('absent') }
        end
      end

      context 'version = [6, 7, 8]' do
        let(:params) { { 'versions' => [6, 7, 8] } }

        it { is_expected.to compile }
        it { is_expected.to compile.with_all_deps }
        it {
          is_expected.to contain_package('centos-release-scl')
            .with_ensure('present')
            .that_comes_before(
              [
                'Package[devtoolset-6]',
                'Package[devtoolset-7]',
                'Package[devtoolset-8]',
              ],
            )
        }
        Array(6..8).each do |version|
          it { is_expected.to contain_package("devtoolset-#{version}").only_with_ensure('present') }
        end
        Array(3..5).each do |version|
          it { is_expected.to contain_package("devtoolset-#{version}").only_with_ensure('absent') }
        end
      end
    end
  end
end
