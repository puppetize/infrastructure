# Bacula client role
class site::bacula::client(
  $password,
  $address            = $::ipaddress,
  $client_name        = $::hostname,
  $director_server    = hiera('bacula_director_server'),
  $director_ipaddress = hiera('bacula_director_ipaddress', undef))
{
  if $director_ipaddress {
    $director_name_array = split($director_server, '[.]')
    $director_name = $director_name_array[0]

    host { $director_server:
      ip           => $director_ipaddress,
      host_aliases => $director_name
    }
  }

  @@bacula::director::client { $client_name:
    address  => $address,
    password => $password
  }
}
