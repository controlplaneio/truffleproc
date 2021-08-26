# truffleproc — hunt secrets in process memory

2021 [@controlplaneio](https://twitter.com/controlplaneio)

<!-- use markdown-toc to generate a table of contents here -->

## Usage

Run `truffleproc.sh` against your current Bash shell (e.g. `$$`):

```shell script
$ ./truffleproc.sh $$
# coredumping pid 6174
Reading symbols from od...
Reading symbols from /usr/lib/systemd/systemd...
Reading symbols from /lib/systemd/libsystemd-shared-247.so...
Reading symbols from /lib/x86_64-linux-gnu/librt.so.1...
Reading symbols from /lib/x86_64-linux-gnu/libseccomp.so.2...
Reading symbols from /lib/x86_64-linux-gnu/libselinux.so.1...
Reading symbols from /lib/x86_64-linux-gnu/libmount.so.1...
Reading symbols from /lib/x86_64-linux-gnu/libpam.so.0...
Reading symbols from /lib/x86_64-linux-gnu/libaudit.so.1...
Reading symbols from /lib/x86_64-linux-gnu/libkmod.so.2...
Reading symbols from /lib/x86_64-linux-gnu/libapparmor.so.1...
Reading symbols from /lib/x86_64-linux-gnu/libc.so.6...
Reading symbols from /lib/x86_64-linux-gnu/libacl.so.1...
Reading symbols from /lib/x86_64-linux-gnu/libblkid.so.1...
Reading symbols from /lib/x86_64-linux-gnu/libcap.so.2...
Reading symbols from /lib/x86_64-linux-gnu/libcrypt.so.1...
Reading symbols from /lib/x86_64-linux-gnu/libgcrypt.so.20...
Reading symbols from /lib/x86_64-linux-gnu/libip4tc.so.2...
Reading symbols from /lib/x86_64-linux-gnu/liblz4.so.1...
Reading symbols from /lib/x86_64-linux-gnu/libzstd.so.1...
Reading symbols from /lib/x86_64-linux-gnu/liblzma.so.5...
Reading symbols from /lib/x86_64-linux-gnu/libdl.so.2...
Reading symbols from /lib/x86_64-linux-gnu/libpthread.so.0...
Reading symbols from /lib64/ld-linux-x86-64.so.2...
Reading symbols from /lib/x86_64-linux-gnu/libpcre2-8.so.0...
Reading symbols from /lib/x86_64-linux-gnu/libcap-ng.so.0...
Reading symbols from /lib/x86_64-linux-gnu/libcrypto.so.1.1...
Reading symbols from /lib/x86_64-linux-gnu/libgpg-error.so.0...
# extracting strings to /tmp/tmp.o6HV0Pl3fe
# finding secrets
# results in /tmp/tmp.o6HV0Pl3fe/results.txt
```

Outputs the secrets and high entropy strings in the memory of the target PID:

```text
# ./truffleproc.sh results for pid 6174 (2021-08-31T15:16:47.077Z) | @controlplaneio
Reason: High Entropy
Date: 2021-08-31 15:16:47
Hash: 53e5372a9b1a2f69374652266908fc447f4077f6
Filepath: strings.txt
Branch: origin/master
Commit: Coredump of strings for pid 6174

+disk/by-id/dm-uuid-LVM-oxjqdaDSHekHKvBllov2EQV9db2JiNUa37CT8R0nuBS6I2qYAaHnxyjoHoDW
+DM_UUID=LVM-oxjqdaDSHekHKvBllov2EQV9db2JiNUa37CT8R0nuBS6I2qYAaHnxyjoHoDW
+API_KEY=BvWmkjg3yhb5dsfF6pstHo466yhrede210c
+SECRET_API_KEY=Ks83htsgjDFGi9dfg1cbvsdgsht3

# ...
```

<!--## Appendix-->


<!--### Sequence Diagram Source Example-->

<!--```-->
<!--@startuml-->
<!--title CP Theme-->
<!--'skinparam handwritten true-->
<!--skinparam {-->
<!--    ArrowColor Black-->
<!--    NoteColor Black-->
<!--    NoteBackgroundColor White-->
<!--    LifeLineBorderColor Black-->
<!--    LifeLineColor Black-->
<!--    ParticipantBorderColor Black-->
<!--    ParticipantBackgroundColor Black-->
<!--    ParticipantFontColor White-->
<!--    defaultFontSize 12-->
<!--    defaultFontStyle Bold-->
<!--    maxMessageSize 140-->
<!--    wrapWidth 400-->
<!--}-->

<!--== 1. title ==-->

<!--"Dev Machine"->Github: commit and push-->
<!--Github->Jenkins: call webhook,\ntrigger build-->

<!--Jenkins->"Build Slave": automated trigger:\ncommit-->

<!--== 2a. image scan ==-->

<!--Jenkins->"Build Slave": automated trigger:\nimage scan-->
<!--@enduml-->
<!--```-->
