DefinitionBlock ("", "SSDT", 2, "INOKI", "RAYTRACE", 0x00000001)
{
    Device (PPM) {         // PPM
        Method (TEST) {     // Output a simple PPM
            Local0 = 255
            Local1 = 255
            printf ("P3\n")
            printf ("%o %o\n", HEDE(Local0), HEDE(Local1))
            printf ("255")

            Local2 = Local0
            while (Local2) {
                Local3 = 0
                while (Local3 < Local1) {
                    printf ("%o %o %o\n",
                        HEDE(Local2 * 255 / Local0),
                        HEDE(Local3 * 255 / Local1),
                        HEDE(1 * 255 / 5)
                    )
                    Local3++
                }
                Local2--
            }
        }

        Method (HEDE, 1) {  // From HEX to HEX-represented DEC
            Local0 = Arg0

            if (Local0 < 10) {
                Return (Local0)
            }

            Local0 = Arg0 % 10
            Local0 = Local0 + ((Arg0 % 100 - Arg0 % 10) / 10) * 0x10
            Local0 = Local0 + (Arg0 / 100) * 0x100

            Return (Local0)
        }
    }
}