#!/bin/bash
# Test if the crash is fixed with Node v18

source ~/.nvm/nvm.sh
nvm use 18.20.0

echo "Running quick Octave test with Node v18..."
octave --no-gui --eval "x = 1:10; y = sin(x); plot(x, y); print('test_crash_fix.png', '-dpng'); disp('Test complete');" 2>&1 | grep -v "QSocketNotifier"

echo ""
echo "If you see this message without 'Illegal instruction (core dumped)', the fix worked!"
