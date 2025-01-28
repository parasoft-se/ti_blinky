
MEMORY
{
PAGE 0 :
   /* BEGIN is used for the "boot to Flash" bootloader mode   */

   BEGIN           	: origin = 0x080000, length = 0x000002
   RAMM           	: origin = 0x0000F6, length = 0x000702 /* on-chip RAM block M1/M2 */

   RAMLS			: origin = 0x008000, length = 0x004000

   RESET           	: origin = 0x3FFFC0, length = 0x000002

   /* Flash sectors */
   /* BANK 0 */
   FLASH_BANK0 		 : origin = 0x080002, length = 0x00FFFE /* on-chip Flash */

   /* BANK 1 */
   FLASH_BANK1		 : origin = 0x090000, length = 0x00FFF0 /* on-chip Flash */

//   FLASH_BANK1_SEC15_RSVD : origin = 0x09FFF0, length = 0x000010  /* Reserve and do not use for code as per the errata advisory "Memory: Prefetching Beyond Valid Memory" */

PAGE 1 :

   BOOT_RSVD       : origin = 0x000002, length = 0x0000F1     /* Part of M0, BOOT rom will use this for stack */
//   RAMM1_RSVD      : origin = 0x0007F8, length = 0x000008     /* Reserve and do not use for code as per the errata advisory "Memory: Prefetching Beyond Valid Memory" */

   RAMGS0      : origin = 0x00C000, length = 0x002000
   RAMGS1      : origin = 0x00E000, length = 0x002000
   RAMGS2      : origin = 0x010000, length = 0x002000
   RAMGS3      : origin = 0x012000, length = 0x001FF8
//   RAMGS3_RSVD : origin = 0x013FF8, length = 0x000008     /* Reserve and do not use for code as per the errata advisory "Memory: Prefetching Beyond Valid Memory" */
}


SECTIONS
{
   codestart        : > BEGIN,     			PAGE = 0, ALIGN(4)
   .text            : >> FLASH_BANK0,   	PAGE = 0, ALIGN(4)
   .cinit           : > FLASH_BANK0,     	PAGE = 0, ALIGN(4)
   .switch          : > FLASH_BANK0,     	PAGE = 0, ALIGN(4)
   .reset           : > RESET,     PAGE = 0, TYPE = DSECT /* not used, */

   .stack           : > RAMLS,     PAGE = 0

#if defined(__TI_EABI__)
   .init_array      : > FLASH_BANK0,       	PAGE = 0,       ALIGN(4)
   .bss             : > RAMLS,       	 	PAGE = 0
   .bss:output      : > RAMLS,       		PAGE = 0
   .bss:cio         : > RAMLS,       		PAGE = 0
   .data            : > RAMLS,       		PAGE = 0
   .sysmem          : > RAMLS,       		PAGE = 0
   /* Initalized sections go in Flash */
   .const           : > FLASH_BANK0,	    PAGE = 0,       ALIGN(4)
#else
   .pinit           : > FLASH_BANK0,       PAGE = 0,       ALIGN(4)
   .ebss            : > RAMLS,       PAGE = 0
   .esysmem         : > RAMLS,       PAGE = 0
   .cio             : > RAMLS,       PAGE = 0
   .econst          : > FLASH_BANK0,    PAGE = 0, ALIGN(4)
#endif

   ramgs0           : > RAMGS0,    PAGE = 1
   ramgs1           : > RAMGS1,    PAGE = 1

 
#if defined(__TI_EABI__) 
   .TI.ramfunc      : LOAD = FLASH_BANK0,
                      RUN = RAMLS,
                      LOAD_START(RamfuncsLoadStart),
                      LOAD_SIZE(RamfuncsLoadSize),
                      LOAD_END(RamfuncsLoadEnd),
                      RUN_START(RamfuncsRunStart),
                      RUN_SIZE(RamfuncsRunSize),
                      RUN_END(RamfuncsRunEnd),
                      PAGE = 0, ALIGN(4)
#else					  
   .TI.ramfunc      : LOAD = FLASH_BANK0,
                      RUN = RAMLS,
                      LOAD_START(_RamfuncsLoadStart),
                      LOAD_SIZE(_RamfuncsLoadSize),
                      LOAD_END(_RamfuncsLoadEnd),
                      RUN_START(_RamfuncsRunStart),
                      RUN_SIZE(_RamfuncsRunSize),
                      RUN_END(_RamfuncsRunEnd),
                      PAGE = 0, ALIGN(4)
#endif

}

/*
//===========================================================================
// End of file.
//===========================================================================
*/
