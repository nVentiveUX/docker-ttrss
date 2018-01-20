<?php
  /*
  This script is adapted from:
    https://git.tt-rss.org/fox/tt-rss/src/master/install/index.php

  It will detect that provided database is reachable and initialize it if empty.
  */

  require "/srv/ttrss/config.php";

  function pdo_connect($host, $user, $pass, $db, $type, $port = false) {
    $db_port = $port ? ';port=' . $port : '';
    $db_host = $host ? ';host=' . $host : '';

    try {
      $pdo = new PDO($type . ':dbname=' . $db . $db_host . $db_port, $user, $pass);

      return $pdo;
    } catch (Exception $e) {
      print($e->getMessage() . "\n");
      return null;
    }
  }

  $pdo = pdo_connect($DB_HOST, $DB_USER, $DB_PASS, $DB_NAME, $DB_TYPE, $DB_PORT);

  if (!$pdo) {
    print("Unable to connect to database using specified parameters.\n");
    exit(2);
  }

  print("Database connection succeeded.\n");

  $res = $pdo->query("SELECT true FROM ttrss_feeds");

  if ($res && $res->fetch()) {
    print("Some tt-rss data already exists in this database. Skipping initialization.\n");
    exit(0);
  }

  print("Initializing a new database...\n");

  $lines = explode(";", preg_replace("/[\r\n]/", "",
              file_get_contents("../schema/ttrss_schema_".basename($DB_TYPE).".sql")));

  foreach ($lines as $line) {
    if (strpos($line, "--") !== 0 && $line) {
      $res = $pdo->query($line);

      if (!$res) {
        print("Query: $line\n");
        print("Error: " . implode(", ", $this->pdo->errorInfo()) . "\n");
        exit(1);
      }
    }
  }

  print("Database initialization completed.\n");
  exit(0);
?>
