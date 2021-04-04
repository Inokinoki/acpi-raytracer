DefinitionBlock ("", "SSDT", 2, "INOKI", "RAYTRACE", 0x00000001)
{
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

    Device (RAY) {
        Method (MAK0) {
            Local0 = Package() {
                0, 0, 0, 0, 0, 0
            }
            Return (Local0)
        }

        Method (MAKE, 2) {
            Local0 = MAK0()
            Local0[0] = derefof(Arg0[0])
            Local0[1] = derefof(Arg0[1])
            Local0[2] = derefof(Arg0[2])
            Local0[3] = derefof(Arg1[0])
            Local0[4] = derefof(Arg1[1])
            Local0[5] = derefof(Arg1[2])
            Return (Local0)
        }

        // Origin
        Method (RORG, 1) {
            Local0 = Package() {
                0, 0, 0
            }
            Local0[0] = derefof(Arg0[0])
            Local0[1] = derefof(Arg0[1])
            Local0[2] = derefof(Arg0[2])
            Return (Local0)
        }

        // Direction
        Method (RDIR, 1) {
            Local0 = Package() {
                0, 0, 0
            }
            Local0[0] = derefof(Arg0[3])
            Local0[1] = derefof(Arg0[4])
            Local0[2] = derefof(Arg0[5])
            Return (Local0)
        }

        Method (PATP, 2) {
            // Arg0: ray, Arg1: t
            Local0 = RORG(Arg0) // A
            Local1 = RDIR(Arg0) // B

            Local2 = \VEC.TMUL(Local1, Arg1)
            // A + t * B
            Return (\VEC.VADD(Local0, Local2))
        }

        Method (TEST) {
            Local0 = Package() {
                0x01, 0x02, 0x03
            }
            Local1 = Package() {
                0x01, 0x02, 0x03
            }
            Return (MAKE(Local0, Local1))
        }
    }
}
