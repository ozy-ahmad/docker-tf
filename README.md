# Deploying docker nodered using Terraform

### Terraform graph command 
- install graphviz to visualize the graph 
`sudo apt install graphviz`
- create pdf file to human readable graph from terraform graph command
`terraform graph | dot -Tpdf > graph-pan.pdf`
- create graph for destroyed plna
` terraform graph -type=plan-destroy | dot -Tpdf > graph-pan-destroyed.pdf `