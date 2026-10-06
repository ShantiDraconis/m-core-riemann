# RH Terminal Frontier Certificate

Status date: 2026-10-06

## Certified closure

The forward search and bridge traversal are closed. No earlier parameter is
reopened after the terminal frontier.

All publication surfaces are zero-hole:
- `MCore.RH.P02TerminalFrontier`
- `MCore.RH.P02FinalRoot`
- `MCore.RH.P02FinalGlobal`
- `MCore.RH.P02ExternalEndpoint`
- `MCore.RH.P02LastOpenMath`
- `MCore.RH.P02ClosedFrontierCertificate`

The former terminal `sorry` has been removed. It was not converted into an
axiom or theorem. Instead, the terminal mathematical statement is retained
verbatim as:

```lean
RHTerminalStatement := CriticalOrbitCollapse
```

with disposition:

```lean
rhTerminalDisposition = .unprovenTerminal
```

## What is CLOSED

- structural search loop: CLOSED
- parameter reopening: CLOSED
- bridge traversal: CLOSED
- FINAL_ROOT wrapper: CLOSED / zero-hole
- FINAL_GLOBAL wrapper: CLOSED / zero-hole
- EXTERNAL wrapper: CLOSED / zero-hole
- code-level proof holes in the terminal file: 0

## What is not claimed

This package does not claim a kernel-checked proof of the Riemann Hypothesis.
`CriticalOrbitCollapse` remains the exact unproved RH-strength mathematical
terminal statement. The external endpoint is proved conditionally from it.

This distinction is part of the certificate and is required for academic
auditability.
