import sys
from pstats import Stats

stats = Stats(sys.argv[1])
stats.sort_stats('cumtime')
stats.print_stats(10)
print(stats.total_tt)
