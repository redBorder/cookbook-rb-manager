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

%pre

%post

%files
%defattr(0755,root,root)
/var/chef/cookbooks/rb-manager

%doc

%changelog
* Tue Oct 18 2016 Alberto Rodríguez <arodriguez@redborder.com> - 1.0.0-1
- first spec version
