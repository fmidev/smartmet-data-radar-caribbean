%define smartmetroot /smartmet

Name:           smartmet-data-radar-caribbean
Version:        17.11.9
Release:        1%{?dist}.fmi
Summary:        SmartMet Data Radar Caribbean
Group:          System Environment/Base
License:        MIT
URL:            https://github.com/fmidev/smartmet-data-radar-caribbean
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
BuildArch:      noarch

%{?el6:Requires: smartmet-qdconversion}
%{?el7:Requires: smartmet-qdtools}
Requires:       wget

%description
TODO

%prep

%build

%pre

%install
rm -rf $RPM_BUILD_ROOT
mkdir $RPM_BUILD_ROOT
cd $RPM_BUILD_ROOT

mkdir -p .%{smartmetroot}/cnf/cron/{cron.d,cron.hourly}
mkdir -p .%{smartmetroot}/editor/radar_caribbean
mkdir -p .%{smartmetroot}/tmp/data/radar_caribbean
mkdir -p .%{smartmetroot}/logs/data
mkdir -p .%{smartmetroot}/run/data/radar_caribbean/bin

cat > %{buildroot}%{smartmetroot}/cnf/cron/cron.d/radar_caribbean.cron <<EOF
*/2 * * * * /smartmet/run/data/radar_caribbean/bin/get_radar_caribbean.sh &> /smartmet/logs/data/radar_caribbean.log
EOF

cat > %{buildroot}%{smartmetroot}/cnf/cron/cron.hourly/clean_data_radar_caribbean <<EOF
#!/bin/sh
# Clean RADAR data
cleaner -maxage 24 '_radar_caribbean_dbz.png' /smartmet/editor/radar_caribbean
EOF

install -m 755 %_topdir/SOURCES/smartmet-data-radar-caribbean/get_radar_caribbean.sh %{buildroot}%{smartmetroot}/run/data/radar_caribbean/bin/

%post

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,smartmet,smartmet,-)
%config(noreplace) %{smartmetroot}/cnf/cron/cron.d/radar_caribbean.cron
%config(noreplace) %attr(0755,smartmet,smartmet) %{smartmetroot}/cnf/cron/cron.hourly/clean_data_radar_caribbean
%{smartmetroot}/*

%changelog
* Thu Nov 9 2017 Mikko Rauhala <mikko.rauhala@fmi.fi> 17.11.9-1.el7.fmi
- Updated requirements
* Wed Jun 28 2017 Mikko Rauhala <mikko.rauhala@fmi.fi> 17.6.28-1.el7.fmi
- Initial Version
