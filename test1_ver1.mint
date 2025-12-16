// CORRECTED MINT 2 CODE - Memristor Pulse Driver for TEC-1
// All inline comments removed for safe upload
// Variable mapping (MINT 2 requires single letters only):
//   p = port address
//   s = SET polarity (0)
//   r = RESET polarity (1)
//   w = pulse width
//   c = count
//   l = polarity (for incremental function)

// ========================================
// UPLOAD-READY VERSION (strip comments before upload):
// ========================================

0 p !
0 s !
1 r !
:S w ! s p /O 1 p /O w () 0 p /O `SET pulse applied` /N ;
:R w ! r p /O 1 p /O w () 0 p /O `RESET pulse applied` /N ;
:D 10 w ! s p /O 1 p /O w () 0 p /O `READ pulse applied` /N ;
:I l ! c ! w ! c ( l p /O 1 p /O w () 0 p /O 100 () ) `Incremental pulses done` /N ;

// ========================================
// HUMAN-READABLE VERSION (for reference only - DO NOT UPLOAD):
// ========================================

// Initialize port and polarity constants
// 0 p !
// 0 s !
// 1 r !

// Function S: Apply SET pulse (lower resistance)
// Stack: width --
// :S
// w !
// s p /O
// 1 p /O
// w ()
// 0 p /O
// `SET pulse applied` /N
// ;

// Function R: Apply RESET pulse (higher resistance)
// Stack: width --
// :R
// w !
// r p /O
// 1 p /O
// w ()
// 0 p /O
// `RESET pulse applied` /N
// ;

// Function D: Read resistance state (non-disturbing)
// Stack: --
// :D
// 10 w !
// s p /O
// 1 p /O
// w ()
// 0 p /O
// `READ pulse applied` /N
// ;

// Function I: Incremental pulses for neuromorphic tuning
// Stack: width count polarity --
// :I
// l !
// c !
// w !
// c (
//   l p /O
//   1 p /O
//   w ()
//   0 p /O
//   100 ()
// )
// `Incremental pulses done` /N
// ;

// ========================================
// USAGE EXAMPLES:
// ========================================
// Change port to 0x10:
// #10 p !
//
// Apply SET pulse (width 1000):
// 1000 S
//
// Apply RESET pulse (width 1500):
// 1500 R
//
// Quick read:
// D
//
// Apply 8 incremental SET pulses (width 300 each):
// 300 8 0 I
//
// Apply 5 incremental RESET pulses (width 500 each):
// 500 5 1 I

// ========================================
// BUGS FIXED FROM ORIGINAL:
// ========================================
// 1. Removed multi-character variables: pol_set -> s, pol_reset -> r, count -> c, pol -> l
// 2. Removed @ operator (pol_set @p /O -> s p /O)
// 3. Removed all inline comments (will corrupt buffer)
// 4. Fixed stack order in :I function
// 5. Ensured spaces before all / operators
