require 'spec_helper'

describe 'scldevtoolset' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'versions argument is not specified' do
        it { is_expected.to compile }
        it { is_expected.to compile.with_all_deps }
        it do
          is_expected.to contain_package('centos-release-scl')
            .with_ensure('present')
            .that_comes_before(['Package[devtoolset-9]'])
        end
        it { is_expected.to contain_package('devtoolset-9').only_with_ensure('present') }
      end

      context 'versions = [8]' do
        let(:params) { { 'versions' => [8] } }

        it { is_expected.to compile }
        it { is_expected.to compile.with_all_deps }
        it do
          is_expected.to contain_package('centos-release-scl')
            .with_ensure('present')
            .that_comes_before(['Package[devtoolset-8]'])
        end
        it { is_expected.to contain_package('devtoolset-8').only_with_ensure('present') }
      end

      context 'versions = [7, 8, 9]' do
        let(:params) { { 'versions' => [7, 8, 9] } }

        it { is_expected.to compile }
        it { is_expected.to compile.with_all_deps }
        it do
          is_expected.to contain_package('centos-release-scl')
            .with_ensure('present')
            .that_comes_before(
              [
                'Package[devtoolset-7]',
                'Package[devtoolset-8]',
                'Package[devtoolset-9]',
              ],
            )
        end
        [7, 8, 9].each do |version|
          it { is_expected.to contain_package("devtoolset-#{version}").only_with_ensure('present') }
        end
      end

      context 'versions = [7, 8, 9] with environment modules' do
        let(:params) do
          { 'versions' => [7, 8, 9],
            'use_modules' => true,
            'install_environment_modules' => true }
        end

        it { is_expected.to compile }
        it { is_expected.to compile.with_all_deps }
        it do
          is_expected.to contain_package('centos-release-scl')
            .with_ensure('present')
            .that_comes_before(
              [
                'Package[devtoolset-7]',
                'Package[devtoolset-8]',
                'Package[devtoolset-9]',
              ],
            )
        end
        [7, 8, 9].each do |version|
          it { is_expected.to contain_package("devtoolset-#{version}").only_with_ensure('present') }
          it do
            is_expected.to contain_file("/etc/modulefiles/scl-devtools/#{version}")
              .with('ensure' => 'link')
              .that_requires('File[/etc/modulefiles/scl-devtools/.base]')
          end
        end
        it do
          is_expected.to contain_file('/etc/modulefiles/scl-devtools')
            .with(
              'ensure' => 'directory',
              'owner'  => 'root',
              'group'  => 'root',
              'mode'   => '0744',
            ).that_requires('Package[environment-modules]')
        end
        it do
          is_expected.to contain_file('/etc/modulefiles/scl-devtools/.base')
            .with(
              'ensure' => 'file',
              'owner'  => 'root',
              'group'  => 'root',
              'mode'   => '0444',
            ).that_requires('File[/etc/modulefiles/scl-devtools]')
        end
      end
    end
  end
end
