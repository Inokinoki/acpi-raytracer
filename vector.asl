DefinitionBlock ("", "SSDT", 2, "INOKI", "RAYTRACE", 0x00000001)
{
    External (\SFPU, DeviceObj)
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

    Device (VEC) {         // Vector
        Method (MAK0) { // Make a 0 Vector
            Local0 = Package() {
                0, 0, 0
            }

            Return (Local0)
        }

        Method (MAKE, 3) {
            Local0 = Package() { 0, 0, 0 }
            Local0[0] = Arg0
            Local0[1] = Arg1
            Local0[2] = Arg2

            Return (Local0)
        }

        Method (VECX, 1) {
            Return (Arg0[0])
        }
        Method (VECY, 1) {
            Return (Arg0[1])
        }
        Method (VECZ, 1) {
            Return (Arg0[2])
        }
        Method (COLR, 1) {
            Return (Arg0[0])
        }
        Method (COLG, 1) {
            Return (Arg0[1])
        }
        Method (COLB, 1) {
            Return (Arg0[2])
        }

        Method (VADD, 2) {
            // Add with vec
            Local0 = MAK0()
            Local0[0] = \SFPU.FADD(derefof(Arg0[0]), derefof(Arg1[0]))
            Local0[1] = \SFPU.FADD(derefof(Arg0[1]), derefof(Arg1[1]))
            Local0[2] = \SFPU.FADD(derefof(Arg0[2]), derefof(Arg1[2]))
            Return (Local0)
        }
        Method (VSUB, 2) {
            // Sub with vec
            Local0 = MAK0()
            Local0[0] = \SFPU.FSUB(derefof(Arg0[0]), derefof(Arg1[0]))
            Local0[1] = \SFPU.FSUB(derefof(Arg0[1]), derefof(Arg1[1]))
            Local0[2] = \SFPU.FSUB(derefof(Arg0[2]), derefof(Arg1[2]))
            Return (Local0)
        }
        Method (VMUL, 2) {
            // Mul with vec
            Local0 = MAK0()
            Local0[0] = \SFPU.FMUL(derefof(Arg0[0]), derefof(Arg1[0]))
            Local0[1] = \SFPU.FMUL(derefof(Arg0[1]), derefof(Arg1[1]))
            Local0[2] = \SFPU.FMUL(derefof(Arg0[2]), derefof(Arg1[2]))
            Return (Local0)
        }
        Method (VDIV, 2) {
            // Div with vec
            Local0 = MAK0()
            Local0[0] = \SFPU.FDIV(derefof(Arg0[0]), derefof(Arg1[0]))
            Local0[1] = \SFPU.FDIV(derefof(Arg0[1]), derefof(Arg1[1]))
            Local0[2] = \SFPU.FDIV(derefof(Arg0[2]), derefof(Arg1[2]))
            Return (Local0)
        }
        Method (TMUL, 2) {
            // Mul with time
            Local0 = MAK0()
            Local0[0] = \SFPU.FMUL(derefof(Arg0[0]), Arg1)
            Local0[1] = \SFPU.FMUL(derefof(Arg0[1]), Arg1)
            Local0[2] = \SFPU.FMUL(derefof(Arg0[2]), Arg1)
            Return (Local0)
        }
        Method (TDIV, 2) {
            // Div with time
            Local0 = MAK0()
            Local0[0] = \SFPU.FDIV(derefof(Arg0[0]), Arg1)
            Local0[1] = \SFPU.FDIV(derefof(Arg0[1]), Arg1)
            Local0[2] = \SFPU.FDIV(derefof(Arg0[2]), Arg1)
            Return (Local0)
        }
        Method (VINV, 1) {
            // Inverse
            Local0 = MAK0()
            Local0[0] = \SFPU.FSUB(0, derefof(Arg0[0]))
            Local0[1] = \SFPU.FSUB(0, derefof(Arg0[1]))
            Local0[2] = \SFPU.FSUB(0, derefof(Arg0[2]))
            Return (Local0)
        }

        Method (VLEN, 1) {
            // Length
            Local0 = 0
            Local1 = \SFPU.FMUL(derefof(Arg0[0]), derefof(Arg0[0]))
            Local2 = \SFPU.FMUL(derefof(Arg0[1]), derefof(Arg0[1]))
            Local3 = \SFPU.FMUL(derefof(Arg0[2]), derefof(Arg0[2]))
            Local4 = \SFPU.FADD(\SFPU.FADD(Local1, Local2), Local3)
            Local0 = \SFPU.SQRT(Local4)
            Return (Local0)
        }
        Method (VUNI, 1) {
            // Make a unit vector
            Local0 = MAK0()
            Local1 = VLEN(Arg0)
            Local0[0] = \SFPU.FDIV(derefof(Arg0[0]), Local1)
            Local0[1] = \SFPU.FDIV(derefof(Arg0[1]), Local1)
            Local0[2] = \SFPU.FDIV(derefof(Arg0[2]), Local1)
            Return (Local0)
        }

        Method (VDOT, 2) {
            // Dot production between 2 vectors
            Local1 = \SFPU.FMUL(derefof(Arg0[0]), derefof(Arg1[0]))
            Local2 = \SFPU.FMUL(derefof(Arg0[1]), derefof(Arg1[1]))
            Local3 = \SFPU.FMUL(derefof(Arg0[2]), derefof(Arg1[2]))
            Local0 = \SFPU.FADD(Local1, \SFPU.FADD(Local2, Local3))
            Return (Local0)
        }

        Method (VCRS, 2) {
            // Cross profuction between 2 vectors
            Local0 = MAK0()
        
            // x
            Local1 = \SFPU.FMUL(derefof(Arg0[1]), derefof(Arg0[2]))
            Local2 = \SFPU.FMUL(derefof(Arg0[2]), derefof(Arg0[1]))
            Local0[0] = \SFPU.FSUB(Local1, Local2)

            // y
            Local1 = \SFPU.FMUL(derefof(Arg0[0]), derefof(Arg0[2]))
            Local1 = \SFPU.FSUB(0, Local1)
            Local2 = \SFPU.FMUL(derefof(Arg0[2]), derefof(Arg0[0]))
            Local0[1] = \SFPU.FSUB(Local1, Local2)

            // z
            Local1 = \SFPU.FMUL(derefof(Arg0[0]), derefof(Arg0[1]))
            Local2 = \SFPU.FMUL(derefof(Arg0[1]), derefof(Arg0[0]))
            Local0[2] = \SFPU.FSUB(Local1, Local2)
            Return (Local0)
        }
    }
}
