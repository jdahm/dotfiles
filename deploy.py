#!/usr/bin/env python2

import sys
import os
import os.path as op
import subprocess as sp
import shutil
import fnmatch

def deploy_file(src, dest, verbose=True, backup=True):
    #ret = sp.call(["ln", "-s", src, dest])
    if backup and op.exists(dest):
        if verbose: print "Creating backup of {}".format(dest)
        shutil.copy(dest, dest+".backup")
    if verbose: print "Copying %s -> %s" % (src, dest)
    shutil.copy(src, dest)

def undeploy_file(dest, verbose=True, backup=True):
    #ret = sp.call(["unlink", dest])
    if backup and op.exists(dest):
        if verbose: print "Creating backup of {}".format(dest)
        shutil.copy(dest, dest+".backup")
    try:
        if verbose: print "Removing %s" % dest
        os.remove(dest)
    except OSError:
        pass

def read_exclude_list(dir):
    patterns = []
    try:
        with open(op.join(dir, "deploy_excludes"), mode="r") as f:
            for l in f:
                patterns.append(l[:-1])
    except IOError:
        pass
    patterns.append("./deploy_excludes")
    return patterns

def deploy_dir(src, reldir, dest, files, excludes):
    destdir = op.abspath(op.join(dest, reldir))
    if not op.isdir(destdir):
        os.makedirs(destdir)
    for f in files:
        relfile = op.join(reldir, f)
        if all(not fnmatch.fnmatch(relfile, p) for p in excludes):
            deploy_file(op.join(src, relfile), op.join(dest, relfile), backup=False)

def undeploy_dir(src, reldir, dest, files, excludes):
    destdir = op.abspath(op.join(dest, reldir))
    for f in files:
        relfile = op.join(reldir, f)
        if all(not fnmatch.fnmatch(relfile, p) for p in excludes):
            undeploy_file(op.join(dest, relfile), backup=False)
    try:
        os.rmdir(op.join(dest, reldir))
    except OSError:
        pass

def deploy_tree(src, dest):
    excludes = read_exclude_list(src)
    for (path, dir, files) in os.walk(src):
        relpath = op.relpath(path, src)
        if all(not fnmatch.fnmatch(relpath, p) for p in excludes):
            deploy_dir(src, relpath, dest, files, excludes)

def undeploy_tree(src, dest):
    excludes = read_exclude_list(src)
    for (path, dir, files) in os.walk(src):
        relpath = op.relpath(path, src)
        if all(not fnmatch.fnmatch(relpath, p) for p in excludes):
            undeploy_dir(src, relpath, dest, files, excludes)

if __name__ == "__main__":
    if len(sys.argv) < 4:
        raise ValueError("Not enough arguments passed")
    src = sys.argv[1]
    if not op.isdir(src):
        raise TypeError("src is not an existing directory")
    dest = sys.argv[2]
    if not op.isdir(dest):
        raise TypeError("dest is not an existing directory")

    action = sys.argv[3]

    if action == "create":
        deploy_tree(src, dest)
    elif action == "remove":
        undeploy_tree(src, dest)
    else:
        print "Unknown action"
