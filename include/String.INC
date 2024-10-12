struc String [text*] {
        common
          db .size
        . db text
        .size = $-.
} 