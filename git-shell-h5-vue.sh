#! /bin/bash
echo "================================"
echo ""
echo "可选参数:"
echo "1 - build"
echo "2 - 提交"
echo "3 - 调试"
echo "4 - 同步master"
echo "5 - 列出提交过的tag列表"
echo "6 - 自动打最后一个tag"
echo "other - 自定义commit提交"
echo ""
echo "请输入您的选择: $1"

commit_message="update";

if test -z "$1"
then
    read dataOne
else
    dataOne=$1
fi

case ${dataOne} in
  1)
    npm run build
    exit
   ;;
  2)
    commit_message="release new version"
  ;;
  3)
    npm run dev
    exit
  ;;
  4)
    git status && git add -A && git commit -m "commit for merge" && git pull origin master
    exit
  ;;
  5)
    git tag --sort version:refname -n10
    exit
  ;;
  6)
    tag="1.0.1"
    tag_list=$(git tag --sort version:refname)
    OLD_IFS="$IFS"
    IFS=" "
    arr=($tag_list)
    IFS="$OLD_IFS"
    tag_length=0;
    for s in ${arr[@]}
    do
        tag_length=`expr ${tag_length} + 1`
    done
    # 判断是否有打过tag
    hundreds=0 # 百位数字
    if test $[tag_length] -gt 0
    then
        num=${tag_length}

        if [ ${num} -ge 1000 ]
        then
            hundreds=`expr ${num} / 1000`
        fi
        num=`expr ${num} % 1000 + 1`
        tag="1.${hundreds}.${num}"
    fi

    echo "push tag: ${tag}"
    git tag ${tag} && git push origin ${tag}
    exit
  ;;
  *)
    commit_message=${dataOne};
  ;;
esac

branch_list=$(git branch | grep '*')
current_branch=${branch_list:2}

npm run build && git status && git add -A && git commit -m "${commit_message}" && git push origin ${current_branch}