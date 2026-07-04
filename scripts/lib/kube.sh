#!/bin/bash

exec_kube() {
	local remote_host="$1"
	[ -z "$remote_host" ] && die "Remote host not specified."

	if [ "$remote_host" = "local" ]; then
		maybe rm -rf ~/kubernetes/project/*
		maybe cp -r ./kubernetes/* ~/kubernetes/project/
		maybe kubectl apply -k ~/kubernetes/project --force
	else
		maybe ssh "$remote_host" rm -rf ~/kubernetes/project/*
		maybe scp -r -v ./kubernetes/* "$remote_host":~/kubernetes/project/
		maybe ssh "$remote_host" 'kubectl apply -k ~/kubernetes/project --force'
	fi
}
