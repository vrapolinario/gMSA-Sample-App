# gMSA sample app

This is a sample application running on Windows containers, simulating an IIS application which tries to authenticate against a Domain controller in Active Directory. This sample is supposed to be used as part of a deployment of gMSA. It can be used on a single node running Windows containers only, generic Kubernetes installation, Azure Kubernetes Service, or any other cloud provider - as long as gMSA is properly enabled. If you configured gMSA in your environment and doesn't have an app to validate if the authentication is working, you can use the app in this image for that. Simply deploy it and you can check if the validation works or not.

## How to use this image

- On a single node: Configure gMSA according to the [Microsoft documentation](https://learn.microsoft.com/en-us/virtualization/windowscontainers/manage-containers/manage-serviceaccounts), deploy the container with:
  
```powershell
docker run --security-opt "credentialspec=file://<credentialspec>.json" --hostname <hostname> -d -p 8080:80 vrapolinario/gmsasampleapp:ltsc2022
```

Open a browser and open http://127.0.0.1:8080/app. You should see a dialog box to provide your credentials. Provide the credentials you configured on your Active Directory and the page should show the resulting authentication.

- On Kubernetes: For a Kubernetes deployment you will need a YAML specification. You can either create one or leverage the ones prepared on this repo. Here's an example specification:

```YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: gmsalm-demo
  labels:
    app: gmsalm-demo
spec:
  replicas: 1
  template:
    metadata:
      name: gmsalm-demo
      labels:
        app: gmsalm-demo
    spec:
      nodeSelector:
        "kubernetes.io/os": windows
      securityContext:
        windowsOptions:
          gmsaCredentialSpecName: <credential spec name>
      containers:
      - name: gmsalm-demo
        image: vrapolinario/gmsasampleapp:ltsc2022
        imagePullPolicy: IfNotPresent
        ports:
          - containerPort: 80
  selector:
    matchLabels:
      app: gmsalm-demo
---
apiVersion: v1
kind: Service
metadata:
  labels:
    app: gmsalm-demo
  name: gmsalm-demo
  namespace: default
spec:
  ports:
    - port: 80
      targetPort: 80
  selector:
    app: gmsalm-demo
  type: LoadBalancer
```

The above spec will deploy the pod running this container image and a service, exposing an external IP address. Use this address to open a browser session to the application and see the result.