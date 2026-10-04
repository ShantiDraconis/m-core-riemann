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


.PHONY: rh-all-gaps rh-clay-questions rh-bridge-decomposition rh-geometry-discovery rh-force-all

rh-all-gaps:
	bash audit/rh_all_gaps.sh

rh-clay-questions:
	bash audit/rh_clay_question_tree.sh

rh-bridge-decomposition:
	bash audit/rh_bridge_decomposition.sh

rh-geometry-discovery:
	bash audit/rh_geometry_discovery.sh

rh-force-all:
	bash audit/rh_force_all_proofs.sh


.PHONY: rh-vasyunin-frontier

rh-vasyunin-frontier:
	bash audit/rh_vasyunin_frontier.sh
