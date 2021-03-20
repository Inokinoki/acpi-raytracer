DefinitionBlock ("", "SSDT", 2, "INOKI", "RAYTRACE", 0x00000001)
{
    External (\SFPU.FADD, MethodObj)
    External (\SFPU.FSUB, MethodObj)
    External (\SFPU.FMUL, MethodObj)
    External (\SFPU.FDIV, MethodObj)
    External (\SFPU.SQRT, MethodObj)

    External (\SFPU.FEQL, MethodObj)
    External (\SFPU.FNEQ, MethodObj)
    External (\SFPU.FGRT, MethodObj)
    External (\SFPU.FGEQ, MethodObj)
    External (\SFPU.FLEQ, MethodObj)
    External (\SFPU.FLET, MethodObj)
    External (\SFPU.SQRT, MethodObj)

    External (\SFPU.F2IN, MethodObj)
    External (\SFPU.IN2F, MethodObj)

    External (\RAY.MAK0, MethodObj)
    External (\RAY.MAKE, MethodObj)
    External (\RAY.PATP, MethodObj)
    External (\RAY.RORG, MethodObj)
    External (\RAY.RDIR, MethodObj)

    External (\VEC.MAK0, MethodObj)
    External (\VEC.MAKE, MethodObj)
    External (\VEC.VECX, MethodObj)
    External (\VEC.VECY, MethodObj)
    External (\VEC.VECZ, MethodObj)
    External (\VEC.COLR, MethodObj)
    External (\VEC.COLG, MethodObj)
    External (\VEC.COLB, MethodObj)
    External (\VEC.VADD, MethodObj)
    External (\VEC.VSUB, MethodObj)
    External (\VEC.VMUL, MethodObj)
    External (\VEC.VDIV, MethodObj)
    External (\VEC.TMUL, MethodObj)
    External (\VEC.TDIV, MethodObj)
    External (\VEC.VINV, MethodObj)
    External (\VEC.VLEN, MethodObj)
    External (\VEC.VUNI, MethodObj)
    External (\VEC.VDOT, MethodObj)
    External (\VEC.VCRS, MethodObj)

    Device (PPM) {         // PPM
        Method (TEST) {     // Output a simple PPM
            printf ("P3\n")
            printf ("%o %o\n", HEDE(255), HEDE(255))
            printf ("255")

            Local7 = Package() {
                // Lower Left corner: -2, -1, -1
                Package() {
                    0xc0000000, 0xbf800000, 0xbf800000
                },
                // Horizontal: 4, 0, 0
                Package() {
                    0x40800000, 0, 0
                },
                // Vertical: 0, 2, 0
                Package() {
                    0, 0x40000000, 0
                },
                // Origin: 0, 0, 0
                Package() {
                    0, 0, 0
                }
            }

            Local2 = 255
            while (Local2) {
                Local3 = 0
                while (Local3 < 255) {
                    Local0 = \SFPU.FDIV(\SFPU.IN2F(Local3), \SFPU.IN2F(255))
                    Local1 = \SFPU.FDIV(\SFPU.IN2F(Local2), \SFPU.IN2F(255))

                    Local0 = \VEC.TMUL(derefof(Local7[1]), Local0)
                    Local1 = \VEC.TMUL(derefof(Local7[2]), Local1)
                    Local4 = \VEC.VADD(derefof(Local7[0]), Local0)
                    Local4 = \VEC.VADD(Local4, Local1)
                    // Ray
                    Local5 = \RAY.MAKE(derefof(Local7[3]), Local4)
                    Local6 = COLO(Local5)
                    printf ("%o %o %o\n",
                        HEDE(\SFPU.F2IN(\SFPU.FMUL(\SFPU.IN2F(255), derefof(Local6[0])))),
                        HEDE(\SFPU.F2IN(\SFPU.FMUL(\SFPU.IN2F(255), derefof(Local6[1])))),
                        HEDE(\SFPU.F2IN(\SFPU.FMUL(\SFPU.IN2F(255), derefof(Local6[2]))))
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

        Method (COLO, 1) {
            // Use a vec3 package to calculate color
            Local0 = \RAY.RDIR(Arg0)
            Local1 = \VEC.VUNI(Local0)
            Local2 = \SFPU.FMUL(0x3f000000, \SFPU.FADD(\SFPU.IN2F(1), \VEC.VECY(Local1)))
            Local3 = \VEC.MAKE(0x3f800000, 0x3f800000, 0x3f800000)    // 1.0 1.0 1.0
            Local5 = \VEC.TMUL(Local3, \SFPU.FSUB(0x3f800000, Local2))

            Local4 = \VEC.MAKE(0x3f000000, 0x3f333333, 0x3f800000)    // 0.5 0.7 1.0
            Local6 = \VEC.TMUL(Local4, Local2)

            Local7 = \VEC.VADD(Local5, Local6)
            Return (Local7)
        }
    }
}