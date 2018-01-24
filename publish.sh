# system "git init"
# system "git add ."
# message = "Site updated at #{Time.now.utc}"
# system "git commit -m #{message.inspect}"
# system "git remote add origin git@github.com:#{GITHUB_REPONAME}.git"
# system "git push origin master --force"

TEMPDIR=`mktemp -d 2>/dev/null || mktemp -d -t 'mytmpdir'`

echo $TEMPDIR

cp -r site/. $TEMPDIR
pushd $TEMPDIR

git init
git add .
git status
git commit -m Updating site from blawg
git remote add origin git@github.com:gypsydave5/gypsydave5.github.io
# git push origin master --force

# popd $TEMPDIR
# rm -rf $TEMPDIR

