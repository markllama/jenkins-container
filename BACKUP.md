# Stuff to back up

Files from buildvm 20180323

## Files

```
com.redhat.jenkins.plugins.ci.GlobalCIConfiguration.xml
com.sonyericsson.rebuild.RebuildDescriptor.xml
config.xml
credentials.xml
github-plugin-configuration.xml
hudson.model.UpdateCenter.xml
hudson.plugins.ansicolor.AnsiColorBuildWrapper.xml
hudson.plugins.build_timeout.operations.BuildStepOperation.xml
hudson.plugins.emailext.ExtendedEmailPublisher.xml
hudson.plugins.git.GitSCM.xml
hudson.plugins.git.GitTool.xml
hudson.plugins.timestamper.TimestamperConfig.xml
hudson.scm.SubversionSCM.xml
hudson.tasks.Mailer.xml
hudson.tasks.Shell.xml
hudson.triggers.SCMTrigger.xml
jenkins.CLI.xml
jenkins.model.ArtifactManagerConfiguration.xml
jenkins.model.DownloadSettings.xml
jenkins.model.JenkinsLocationConfiguration.xml
jenkins.security.QueueItemAuthenticatorConfiguration.xml
jenkins.security.UpdateSiteWarningsConfiguration.xml
nodeMonitors.xml
org.jenkinsci.plugins.pipeline.modeldefinition.config.GlobalConfig.xml
org.jenkinsci.plugins.workflow.flow.FlowExecutionList.xml
org.jenkinsci.plugins.workflow.libs.GlobalLibraries.xml
scriptApproval.xml
```

## Directories

```
./update-center-rootCAs
./fingerprints
#./jobs          # BIG ACTIVE
#./logs          # TEMPORARY
./nodes 
#./plugins       # REPRODUCABLE
#./secrets       # SENSITIVE
./updates
#./userContent   # EMPTY
./users
#./workflow-libs # EMPTY
#./workspace     # TMP BIG
```


## Jobs

```
(cd /mnt/nfs/jenkins_home ; tar --exclude jobs --exclude logs --exclude caches --exclude secrets --exclude plugins --exclude workspace --exclude identity.key.enc -czf ~/buildvm-jenkins-config-backup-$(date +%Y%m%d-%H%M%S).tar.gz *)

tar --exclude builds -C /mnt/nfs/jenkins_home -czf ~/buildvm-jenkins-jobs-backup-$(date +%Y%m%d-%H%M%S).tar.gz jobs
```


## Restore 


