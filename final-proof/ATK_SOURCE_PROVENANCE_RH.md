# ATK source provenance — RH

- Original source: `lean/MCore/Material/Closure.lean`
- Original blob SHA: `197dd3d32059a231188eea65e61f517005f40493`
- Finding: RHClosure requires a concrete logarithmic bound.
- Classification: SOURCE; material terminal proof not established by this source alone.
- Action: migrate exact declarations and transitive dependencies into `lean/ATK/RH_MaterialDense.lean` before kernel certification.
- No OPEN_MATH/CLOSED_MATH flag is promoted by this record.
