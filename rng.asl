DefinitionBlock ("", "SSDT", 2, "INOKI", "RAYTRACE", 0x00000001)
{
    Name (SEED, 1)
    Device (SRNG) {         // Random Number Generator
        Method (NEXT) {
            SEED = SEED * 1103515245 + 12345
            Return ((SEED / 65536) % 32768)
        }
        
        Method (SRNG, 1) {
            SEED = Arg0
        }
    }
}
