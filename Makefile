SHELL := /usr/bin/env bash

.PHONY: bootstrap rh-kernel rh-preflight rh-axioms mcore

bootstrap:
	bash audit/bootstrap_lean_environment.sh

rh-preflight:
	bash audit/rh_preflight_kernel.sh

rh-axioms:
	lake env lean audit/RHKernelAxiomAudit.lean

rh-kernel:
	bash audit/rh_terminal_kernel_check.sh

mcore:
	lake build MCore


.PHONY: rh-material-gate
rh-material-gate:
	bash audit/rh_material_gate.sh


.PHONY: rh-discover
rh-discover:
	bash audit/rh_discovery_kernel.sh
