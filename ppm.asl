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
        Name (CVEC, Package() {
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
        })

        // Name Hittable Type
        Name (HTSP, 0x01)
        // Name Hittable Count
        Name (HCNT, 1)

        // Hittable list
        Name (HITL, Package() {
            Package() {
                // type: sphere
                0x01,
                // center
                0, 0, 0xbf800000,
                // r
                0x3f000000
            }
        })

        // Hit record as a return value
        Name (HITR, Package() {
            // t
            0x0,
            // p
            0, 0, 0,
            // normal
            0, 0, 0
        })
        Name (HIT1, Package() {
            // t
            0x0,
            // p
            0, 0, 0,
            // normal
            0, 0, 0
        })

        Method (TEST) {     // Output a simple PPM
            printf ("P3\n")
            printf ("%o %o\n", HEDE(200), HEDE(100))
            printf ("255")

            Local2 = 100    // j
            while (Local2) {
                Local3 = 0  // i
                while (Local3 < 200) {
                    Local0 = \SFPU.FDIV(\SFPU.IN2F(Local3), \SFPU.IN2F(200))
                    Local1 = \SFPU.FDIV(\SFPU.IN2F(Local2), \SFPU.IN2F(100))

                    Local0 = \VEC.TMUL(derefof(CVEC[1]), Local0)
                    Local1 = \VEC.TMUL(derefof(CVEC[2]), Local1)
                    Local4 = \VEC.VADD(derefof(CVEC[0]), Local0)
                    Local4 = \VEC.VADD(Local4, Local1)
                    // Ray
                    Local5 = \RAY.MAKE(derefof(CVEC[3]), Local4)
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
            // Hit sth
            if (HITW(Arg0, 0, 0x55555555)) {
                Local0 = \VEC.MAKE(derefof(HITR[4]), derefof(HITR[5]), derefof(HITR[6]))
                Local1 = \VEC.MAKE(\SFPU.FADD(\VEC.VECX(Local0), 0x3f800000), \SFPU.FADD(\VEC.VECY(Local0), 0x3f800000), \SFPU.FADD(\VEC.VECZ(Local0), 0x3f800000))
                Return (\VEC.TMUL(Local1, 0x3f000000))
            }
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

        Method (HSPH, 3) {
            
        }

        // Check HIT on each object
        Method (HITW, 3) {
            // Arg0: ray, Arg1: t_min, Arg2: t_max
            Local0 = 0  // Hit anything
            Local1 = Arg2   // Closest
            Local2 = 0
            while (Local2 < HCNT) {
                if (derefof(HITL[Local2][0]) == HTSP) {
                    // Is a sphere
                    if (HISP(HITL[Local2], Arg0, Arg1, Local1)) {
                        Local0 = 1  // Hit sth
                        Local1 = derefof(HIT1[0])

                        // Rec = temp Rec
                        HITR[0] = derefof(HIT1[0])
                        HITR[1] = derefof(HIT1[1])
                        HITR[2] = derefof(HIT1[2])
                        HITR[3] = derefof(HIT1[3])
                        HITR[4] = derefof(HIT1[4])
                        HITR[5] = derefof(HIT1[5])
                        HITR[6] = derefof(HIT1[6])
                    }
                }
                Local2 = Local2 + 1
            }
            Return (Local0)
        }

        Method (SPHC, 1) {
            // Sphere center
            Return (\VEC.MAKE(derefof(Arg0[1]), derefof(Arg0[2]), derefof(Arg0[3])))
        }

        Method (SPHR, 1) {
            // Sphere radius
            Return (derefof(Arg0[4]))
        }

        Method (HISP, 4) {
            // Arg0: sphere, Arg1: ray, Arg2: t_min, Arg3: t_max
            Local0 = \VEC.VSUB(\RAY.RORG(Arg1), SPHC(Arg0))   // oc
            Local1 = \VEC.VDOT(\RAY.RDIR(Arg1), \RAY.RDIR(Arg1))    // a
            Local2 = \VEC.VDOT(Local0, \RAY.RDIR(Arg1))
            Local3 = \SFPU.FMUL(\SFPU.IN2F(2), Local2)  // b
            Local4 = \VEC.VDOT(Local0, Local0)
            Local5 = \SFPU.FSUB(Local4, \SFPU.FMUL(SPHR(Arg0), SPHR(Arg0)))    // c
            Local6 = \SFPU.FMUL(Local3, Local3)
            Local7 = \SFPU.FMUL(\SFPU.FMUL(\SFPU.IN2F(4), Local1), Local5)

            Local0 = \SFPU.FSUB(Local6, Local7)     // discriminant
            if (\SFPU.FLET(Local0, 0)) {
                // No root
                Return (0)
            } else {
                // Has at least one root, return the near one
                // Local0: discriminant, Local1: a, Local3: b
                // TODO
                Local2 = \SFPU.FSUB(0, Local3)
                Local4 = \SFPU.SQRT(Local0)
                Local5 = \SFPU.FSUB(Local2, Local4)
                Local6 = \SFPU.FMUL(0x40000000, Local1)
                Local7 = \SFPU.FDIV(Local5, Local6)
                if (\SFPU.FGRT(Local7, Arg2) && \SFPU.FGRT(Local7, Arg3))

                Local2 = \VEC.VSUB(\RAY.PATP(Arg0, Local1), Local0)
                Local2 = \VEC.VUNI(Local2)
                Local3 = \VEC.MAKE(\SFPU.FADD(\VEC.VECX(Local2), 0x3f800000), \SFPU.FADD(\VEC.VECY(Local2), 0x3f800000), \SFPU.FADD(\VEC.VECZ(Local2), 0x3f800000))
                Return (\VEC.TMUL(Local3, 0x3f000000))
                Return ()
            }
        }
    }
}