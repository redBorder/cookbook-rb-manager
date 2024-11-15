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
if [ -d /var/chef/cookbooks/rb-manager ]; then
    rm -rf /var/chef/cookbooks/rb-manager
fi

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

%postun
# Deletes directory when uninstall the package
if [ "$1" = 0 ] && [ -d /var/chef/cookbooks/rb-manager ]; then
  rm -rf /var/chef/cookbooks/rb-manager
fi

%files
%defattr(0755,root,root)
/var/chef/cookbooks/rb-manager
%defattr(0644,root,root)
/var/chef/cookbooks/rb-manager/README.md

%doc

%changelog
* Thu Oct 10 2024 Miguel Negrón <manegron@redborder.com>
- Add pre and postun

* Fri Jan 19 2024 Miguel Negron <manegron@redborder.com>
- Add journalctld configuration

* Fri Jan 19 2024 David Vanhoucke <dvanhoucke@redborder.com>
- Add arubacentral

* Thu Jan 18 2024 Miguel Negron <manegron@redborder.com>
- Add journalctld configuration

* Thu Dec 21 2023 Nils Verschaeve <malvarez@redborder.com>
- Pass correct kafka brokers to pmacctd

* Mon Dec 18 2023 Miguel Álvarez <malvarez@redborder.com>
- Add rb-logstatter

* Mon Dec 18 2023 Vicente Mesa <vimesa@redborder.com>
- Fix kafka configuration on http2k service

* Fri Dec 15 2023 David Vanhoucke <dvanhoucke@redborder.com>
- Add sync ip support for zookeeper, druid, memcached and postgresql

* Fri Dec 01 2023 Miguel Negrón <manegron@redborder.com>
- Add sync ip support

* Fri Dec 01 2023 David Vanhoucke <dvanhoucke@redborder.com>
- Add selinux

* Wed Nov 29 2023 Miguel Álvarez <malvarez@redborder.com>
- Add cgroup

* Thu Sep 28 2023 Miguel Negrón <manegron@redborder.com>
- Add rbaioutliers

* Mon Jun 26 2023 Luis J. Blanco <ljblanco@redborder.com>
- GeoIP removed from service list

* Fri May 05 2023 Luis J. Blanco <ljblanco@redborder.com>
- Tiers added for druid historical

* Thu May 04 2023 Luis J. Blanco <ljblanco@redborder.com>
- Add Ohai

* Mon Apr 24 2023 Luis J. Blanco <ljblanco@redborder.com>
- Permission scalling

* Tue Apr 18 2023 Luis J. Blanco <ljblanco@redborder.com>
- device sensor

* Wed Feb 15 2023 Luis Blanco <ljblanco@redborder.com>
- sensors info updated and filtered by parent_id

* Fri Feb 3 2023 Luis J. Blanco <ljblanco@redborder.com>
- integrate freeradius in proxy

* Fri Jan 28 2022 David Vanhoucke <dvanhoucke@redborder.com>
- exchange s3 attributes with druid

* Wed Jan 31 2018 Juan J. Prieto <jjprieto@redborder.com>
- Add postgresql 

* Mon Jan 29 2018 Juan J. Prieto <jjprieto@redborder.com>
- Add logstash

* Tue Oct 18 2016 Alberto Rodríguez <arodriguez@redborder.com>
- first spec version
