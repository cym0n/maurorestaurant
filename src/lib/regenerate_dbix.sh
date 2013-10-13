#!/usr/bin/bash
#dbicdump -o dump_directory=. -o components='["InflateColumn::DateTime"]' -o overwrite_modifications=true DjakaWeb::DjakartaDB dbi:SQLite:../DB/djaka.db  '{ quote_char => "\"" }'
dbicdump -o dump_directory=. -o components='["InflateColumn::DateTime"]' Mauro::MauroDB dbi:mysql:database=mauro mauro mauro  

