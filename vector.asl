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
        }
        Method (VSUB, 2) {
            // Sub with vec
        }
        Method (VMUL, 2) {
            // Mul with vec
        }
        Method (VDIV, 2) {
            // Div with vec
        }
        Method (TMUL, 2) {
            // Mul with time
        }
        Method (TDIV, 2) {
            // Div with time
        }
        Method (VINV, 1) {
            // Inverse
        }

        Method (VLEN, 1) {
            // Length
        }
        Method (VUNI, 1) {
            // Make a unit vector
        }

        Method (VDOT, 2) {
            // Dot production between 2 vectors
        }

        Method (VCRS, 2) {
            // Cross profuction between 2 vectors
        }
    }
}
