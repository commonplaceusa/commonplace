import commands

# Run trials

trials = 10
total = 0

for i in range(0,trials):
    _, time = commands.getstatusoutput("python web_profiler.py fallschurch.ourcommonplace.com | grep \"page load\" | awk '{print $1}'")
    total += float(time)
    print "Trial", i, "took", time, "seconds"

print "Total load time:", total
print "Average load time:", (total/trials)

