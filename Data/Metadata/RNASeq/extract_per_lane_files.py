import sys, os

ifile = sys.stdin

per_lane_files = {}
for line in ifile:
    fasta_file = line.strip("\n\r")
    run = os.path.split(os.path.dirname(fasta_file))[-1]
    ff = os.path.basename(fasta_file).replace("_f.fastq.gz","").replace(".fastq.gz","")
    ff_fields = ff.split("_")
    sample = "_".join(ff_fields[0:1])
    index = ff_fields[1]
    lane = ff_fields[2]
    pair_end = ff_fields[3]
    part = ff_fields[4]

    fkey = (sample,lane)
    complete_key = (sample,lane,part)

    if not fkey in per_lane_files:
        per_lane_files[fkey] = {"R1": {}, "R2": {}}

    per_lane_files[fkey][pair_end][complete_key] = fasta_file

for s in sorted(per_lane_files.keys()):
    reps = sorted(per_lane_files[s]["R1"].keys())
    r1 = []
    r2 = []
    for r in reps:
        r1.append(per_lane_files[s]["R1"][r])
        r2.append(per_lane_files[s]["R2"][r])
    print "%s\t%s\t%s" % ("_".join(s), ",".join(r1), ",".join(r2) )
    #ofile.write("%s\t%s\t%s\n" % ("_".join(s), ",".join(r1), ",".join(r2) ) )

