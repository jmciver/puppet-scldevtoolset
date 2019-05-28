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
        it { is_expected.to contain_package('devtoolset-6').only_with_ensure('present') }
        it { is_expected.to contain_package('devtoolset-7').only_with_ensure('present') }
        it { is_expected.to contain_package('devtoolset-8').only_with_ensure('present') }
      end
    end
  end
end
