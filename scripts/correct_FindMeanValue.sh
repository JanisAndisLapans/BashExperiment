#!/bin/bash

column_number=$(head -1 products.csv | tr ',' '\n' | nl | grep -n "price" | cut -d ":" -f 1)
mean_value=$(csvtool col $column_number products.csv | tail -n +2 | awk '{sum+=$1} END {printf("%.6f\n", sum/NR)}')

echo "Mean: $mean_value"