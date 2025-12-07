# [BUG] Illegal instruction crash on older CPUs lacking SSE4/AVX support

## Environment

- **Claude Code version**: 2.0.60
- **Node.js version**: v22.21.1
- **npm version**: 10.9.4
- **CPU**: Pentium(R) Dual-Core CPU E6600 @ 3.06GHz (circa 2008)
- **CPU instruction sets**: SSE, SSE2, SSE3, SSSE3
- **Missing instructions**: SSE4.1, SSE4.2, AVX, AVX2
- **OS**: Linux 6.8.0-88-generic
- **Architecture**: x86_64
- **Platform**: Ubuntu-based distribution

## Description

Claude Code crashes with `Illegal instruction (core dumped)` when rendering terminal UI elements after long-running background processes complete. The crash occurs specifically when interactive prompts or UI updates are displayed (e.g., "accept edits on", "? for shortcuts", todo list animations).

## Root Cause Analysis

Node.js v22 appears to use CPU instructions (likely SSE4.2 or AVX) that are not supported by older processors. The Pentium E6600 only supports instruction sets up to SSSE3, which predates SSE4.1 (introduced in 2006-2008 Intel Core architecture).

The "Illegal instruction" error indicates the binary is attempting to execute a CPU instruction that the processor doesn't recognize, causing an immediate SIGILL signal and core dump.

## Steps to Reproduce

1. Run Claude Code on a pre-2010 CPU without SSE4/AVX support
2. Execute any long-running bash command (e.g., Octave/MATLAB script that takes >30 seconds)
3. Observe that the command completes successfully
4. Crash occurs when Claude Code attempts to render interactive UI elements or update the todo list widget
5. Terminal displays: `Illegal instruction (core dumped)`

## Example from chat.log

```
● Bash(octave --no-gui run_sim_windowed.m 2>&1 | grep -v "QSocketNotifier") timeout: 30s
  ⎿  Running memristor simulation with Joglekar window function...
     Plot saved to: memristor_hysteresis.png
     ... (simulation completes successfully)

∴ Thought for 1s

✻ Saving plot to file… (esc to interrupt · ctrl+t to hide todos · 1m 18s · ↑ 3.3k tokens)
  ⎿  ☒ Add window function to improve hysteresis loop
     ☒ Adjust parameters for better loop shape
     ☐ Save plot to file for visualization

────────────────────────────────────────────────────────
>
────────────────────────────────────────────────────────
  ⏵⏵ accept edits on (shift+tab to cycle)
Illegal instruction (core dumped)
```

## Expected Behavior

Claude Code should either:
1. **Gracefully degrade** on older CPUs by detecting available instruction sets and using compatible code paths
2. **Document minimum CPU requirements** (e.g., "Requires SSE4.2 or AVX support")
3. **Provide a compatibility mode** flag or environment variable to disable advanced CPU optimizations
4. **Use runtime CPU detection** in the UI rendering layer to avoid unsupported instructions

## Current Workaround

Downgrade to Node.js v18 which has broader CPU compatibility:
```bash
nvm install 18.20.0
nvm use 18.20.0
npm install -g @anthropic-ai/claude-code
```

## Impact

This affects users running:
- Older hardware (pre-2010 Intel CPUs, early AMD Phenom/Athlon)
- Virtual machines with limited CPU feature emulation
- Embedded systems or low-power devices
- Enterprise environments with legacy hardware

## Additional Notes

The crash does NOT occur during normal Claude Code operations - only when the terminal UI needs to render complex interactive elements after background process completion. The actual command execution (Octave, bash, etc.) works perfectly; the crash is entirely in Claude Code's UI layer.

## System Information

```
CPU flags: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
pse36 clflush dts acpi mmx fxsr sse sse2 ht tm pbe syscall nx lm constant_tsc
arch_perfmon pebs bts rep_good nopl cpuid aperfmperf pni dtes64 monitor ds_cpl
vmx est tm2 ssse3 cx16 xtpr pdcm xsave lahf_lm pti tpr_shadow flexpriority vpid
dtherm vnmi
```

Notable absence: No `sse4_1`, `sse4_2`, `avx`, `avx2` flags

## Files Available

I can provide:
- Complete `chat.log` showing multiple crash occurrences
- Core dump file (if needed for debugging)
- CPU details from `/proc/cpuinfo`
