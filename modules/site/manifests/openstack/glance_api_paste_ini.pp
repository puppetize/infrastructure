# Fix the file format of glance-api-paste.ini.
#
# The default version of this file that is installed by the Debian package
# includes three lines whare aren't valid in pure ini-style files:
#
#   [composite:rootapp]
#   paste.composite_factory = glance.api:root_app_factory
#   /: apiversions
#   /v1: apiv1app
#   /v2: apiv2app
#
# The separator character in these three lines will be changed to "=".
class site::openstack::glance_api_paste_ini
{
  $file = '/etc/glance/glance-api-paste.ini'

  exec { 'fix glance-api-paste.ini':
    command => "/bin/sed -i -r 's/^(\\/[^=:]*):(.+)$/\\1 =\\2/' ${file}",
    onlyif  => "/bin/grep '^/[^=:]*:' ${file}",
    require => File[$file],
    notify  => Service['glance-api']
  }

  Exec['fix glance-api-paste.ini'] -> Glance_image<||>
}
