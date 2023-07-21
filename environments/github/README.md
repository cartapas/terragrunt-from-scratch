# Where is S3 and dynamoDB
- state file in infinum-doo AWS

# How to set up a local run

These steps need to be done:
- create "personal access token" on Github Settings
- grant permissions:
```
 repo Full control of private repositories
 admin:org Full control of orgs and teams, read and write org projects
 delete_repo Delete repositories
```
- add a token to ENVIRONMENT variables as GITHUB_TOKEN

# How to use module

This directory contains "main.tf" that calls the module for creating a GitHub repository. Main should be set up in a way that is clear to everybody what repo is, who is maintainer, is it achieved or not, is it template repository, and is this repository created from the template.

Examples:

```
module "sample-terraform-repository" {
  source = "../../modules/github/repository"

  repository_name       = "terraform-sample-test"   <-- * repository name construted from words "terraform-" + "project name"
  repository_visibility = "private"                 <-- is repository private / pubilc (DEFAULT private)
  team_member           = ["petarmarinac"]          <-- * team/repository maintainer
  archived              = false                     <-- arhived or not (DEFAULT false)
  permission            = "push"                    <-- team permisions (DEFAULT push) "push = write"
  is_template           = true                      <-- is it "tepmlate repository" or "normal repository" (DEFAULT false)
  
  template = [                                      <-- dynamic load of template repository from witch repository is created (DEFAULT is empty,.. "NO TEMPLATE")
    {
      owner       = "Infinum"               <-- template owner of repository
      repository  = "terraform-template"    <-- template repository name
    }
  ]
}
```

variables marked with * are mandatory, they don't have default values.