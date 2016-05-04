# time find . -not -type d -not -wholename '*.svn*' -not -wholename '*.git*' \
#     -exec echo -n "{} " >> /tmp/nomos.log \; \
#     -exec /usr/share/fossology/nomos/agent/nomos {} >> /tmp/nomos.log \;
# cd /tmp
# grep -v No_license_found nomos.log > nomos-licenses.log
# 

import os
from collections import defaultdict

def print_common_ancestor(license, filenames):
    # take the first filename
    # remove its last path component
    # check if that string is the beginning of every filename
    # loop
    path = filenames[0]
    while len(path) > 0:
        path, _ = os.path.split(path)
        if all([f.startswith(path) for f in filenames]):
            break
    print path, "\t\t", license
    # verbose:
    # print license
    # for filename in filenames:
    #     print "   ", filename
    # print license, path
    # print


def main():
    # keep a hash of license -> filenames.
    # group files by license as we scan,
    #   adding them to a list,
    #   then find common ancestor dir of that group

    # 'licensename': ['path1', 'path2' ...]
    # defaultdict will return an empty list when we look for
    # a key that doesn't exist
    license_filenames = defaultdict(list)
    cur_license = ''
    cur_filenames = []

    f = open('nomos-licenses.log', 'r')

    for line in f:
        tokens = line.lstrip('./').rstrip().split(' ')
        filename = tokens[0]
        license = tokens[len(tokens) - 1]

        license_filenames[license].append(filename)

        if license == cur_license:
            cur_filenames.append(filename)
        else:
            if len(cur_filenames) > 1:
                print_common_ancestor(license, cur_filenames)
            cur_license = license
            cur_filenames = []

    f.close()

    # for license in sorted(license_filenames.iterkeys()):
    #     count = len(license_filenames[license])
    #     print "%s: %d files" % (license, count)
    #     if count <= 4:
    #         for filename in license_filenames[license]:
    #             print "   ", filename

if __name__ == '__main__':
    main()
