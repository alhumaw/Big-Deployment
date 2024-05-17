To build:

1) apache-midterm:
	docker build -t localhost:32000/apache-1:k8s
	docker push localhost:32000/apache-1:k8s

2) lighttpd-miderm:
	docker build -t localhost:32000/lighttpd-1:k8s
	docker push localhost:32000/lighttpd-1:k8s

3) nginx-midterm:
	docker build -t localhost:32000/nginx-1:k8s
	docker push localhost:32000/nginx-1:k8s

4) demo:
	microk8s.kubectl apply -f balance-svc.yaml
	microk8s.kubectl apply -f apache-deploy.yaml
	microk8s.kubectl apply -f lighttpd-deploy.yaml
	microk8s.kubectl apply -f nginx-deploy.yaml

5) test:
	curl the load balancer IP address with a -I flag repeatedly to confirm the webservers do change
	nmap: nmap -sV -Pn -p 8000 <cluster-ip> 

