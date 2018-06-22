Name:		nagios-plugins-satellite_service
Version:	0.2
Release:	1%{?dist}
Summary:	Red Hat Satellite 6 plugin for Icinga/Nagios

Group:		Applications/System
License:	GPLv3
URL:		https://github.com/scrat14/check_satellite_service
Source0:	check_satellite_service-%{version}.tar.gz
BuildRoot:	%{_tmppath}/check_satellite_service-%{version}-%{release}-root

%description
This plugin for Icinga/Nagios is used to monitor status of Red Hat
Satellite 6 / Katello services.

BuildRequires: nagios-plugins

%prep
%setup -q -n check_satellite_service-%{version}

%build
%configure --prefix=%{_libdir}/nagios/plugins \
	   --with-nagios-user=nagios \
	   --with-nagios-group=nagios

make all


%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT INSTALL_OPTS=""

%clean
rm -rf $RPM_BUILD_ROOT


%files
%defattr(0755,nagios,nagios)
%{_libdir}/nagios/plugins/check_satellite_service
%doc README INSTALL NEWS ChangeLog LICENSE



%changelog
* Fri Jun 22 2018 Rene Koch <rkoch@rk-it.at> 0.2-1
- Fix path to katello-service as it changed in Satellite 6.3
* Thu Nov 03 2016 Rene Koch <rkoch@rk-it.at> 0.1-1
- Initial build.
