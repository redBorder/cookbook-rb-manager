Name: cookbook-rb-manager
Version: %{__version}
Release: %{__release}%{?dist}
BuildArch: noarch
Summary: redborder manager cookbook to install and configure the redborder environment

License: AGPL 3.0
URL: https://github.com/redBorder/cookbook-rb-manager
Source0: %{name}-%{version}.tar.gz

%description
%{summary}

%prep
%setup -qn %{name}-%{version}

%build

%install
mkdir -p %{buildroot}/var/chef/cookbooks/rb-manager
cp -f -r  resources/* %{buildroot}/var/chef/cookbooks/rb-manager/
chmod -R 0755 %{buildroot}/var/chef/cookbooks/rb-manager
install -D -m 0644 README.md %{buildroot}/var/chef/cookbooks/rb-manager/README.md

%pre

%post
case "$1" in
  1)
    # This is an initial install.
    :
  ;;
  2)
    # This is an upgrade.
    su - -s /bin/bash -c 'source /etc/profile && rvm gemset use default && env knife cookbook upload rb-manager'
  ;;
esac

%files
%defattr(0755,root,root)
/var/chef/cookbooks/rb-manager
%defattr(0644,root,root)
/var/chef/cookbooks/rb-manager/README.md

%doc

%changelog
* Thu May 04 2023 Luis J. Blanco <ljblanco@redborder.com> - 1.5.11
- Add Ohai
* Mon Apr 24 2023 Luis J. Blanco <ljblanco@redborder.com> - 1.5.10
- Permission scalling
* Tue Apr 18 2023 Luis J. Blanco <ljblanco@redborder.com> - 1.5.9
- device sensor
* Wed Feb 15 2023 Luis Blanco <ljblanco@redborder.com> - 1.5.8
- sensors info updated and filtered by parent_id
* Fri Feb 3 2023 Luis J. Blanco <ljblanco@redborder.com> - 1.5.7
- integrate freeradius in proxy
* Fri Jan 28 2022 David Vanhoucke <dvanhoucke@redborder.com> - 1.2.8-1
- exchange s3 attributes with druid
* Wed Jan 31 2018 Juan J. Prieto <jjprieto@redborder.com> - 1.0.0-1
- Add postgresql 
* Mon Jan 29 2018 Juan J. Prieto <jjprieto@redborder.com> - 1.0.0-1
- Add logstash
* Tue Oct 18 2016 Alberto Rodríguez <arodriguez@redborder.com> - 1.0.0-1
- first spec version
