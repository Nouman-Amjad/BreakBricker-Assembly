# Break Bricker: Assembly Language Project

## Overview
Break Bricker is an interactive game implemented entirely in assembly language as part of the Computer Organization and Assembly Language (COAL) course. The project showcases the use of low-level programming techniques, hardware interaction, and efficient resource management.

## Gameplay
Break Bricker is a classic brick-breaking game built in Assembly Language. Here's a visual walkthrough:

### Screenshots
1. **Game Start**
   - The game begins with a paddle and a ball ready to break bricks.
   ![Game Start](assets/screenshot_1.png)

2. **Gameplay in Progress**
   - The player uses the paddle to keep the ball in play while breaking bricks.
   ![Gameplay](assets/screenshot_2.png)

3. **Level Completion**
   - Successfully breaking all bricks advances to the next level.
   ![Level Completion](assets/screenshot_3.png)


## Features
- **Core Gameplay**:
  - A classic brick-breaking game where the player controls a paddle to break bricks.
  - Real-time paddle movement and collision detection.
- **Game Mechanics**:
  - Score tracking and level progression.
  - Multiple levels with increasing difficulty.
- **Assembly Concepts**:
  - Register-based operations.
  - Memory management and hardware interaction.
  - Efficient use of loops, conditionals, and control structures.

## Technology Stack
- **Language**: Assembly Language (x86 architecture).
- **Assembler**: [Specify Assembler, e.g., MASM, NASM, TASM].
- **System Requirements**:
  - Operating System: [Specify OS, e.g., Windows, Linux].
  - Compatible with x86 architecture.

## Installation and Running the Game
1. Clone the repository:
   ```bash
   git clone https://github.com/Nouman-Amjad/BreakBricker-Assembly.git
2. Navigate to the project directory:
   ```bash
   cd BreakBricker-Assembly
3. Assemble the code:
   ```bash
   masm BreakBricker.asm
4. Link the assembled code:
   ```bash
   link BreakBricker.obj
5. Link the assembled code:
   ```bash
   BreakBricker.exe

## Gameplay Instructions
- Use the [Arrow Keys/Keys] to move the paddle.
- Break all the bricks to advance to the next level.
- Avoid missing the ball to prevent losing lives.

## Files
- **BrickBreaker.cpp**: Main assembly code for the game.
- **Assests**: Directory containing any additional resources.

## Gameplay Instructions
- Gained hands-on experience with low-level programming in assembly language.
- Developed efficient memory management and hardware control techniques.
- Implemented a real-time game using assembly instructions and interrupts.

## Future Enhancements
- Add sound effects for collisions and level progression.
- Introduce power-ups like multi-ball and paddle expansion.
- Enhance visuals with advanced graphics.

## Acknowledgments
Special thanks to the faculty at FAST-NUCES for their guidance and support during this project.

## License
This project is licensed under the MIT License.
