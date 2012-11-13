# Install VirtualBox on this system.
class site::virtualbox
{
  require downcase("${name}::${::osfamily}")
}
