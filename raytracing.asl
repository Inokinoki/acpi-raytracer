DefinitionBlock ("", "DSDT", 2, "INOKI", "RAYTRACE", 0x00000001)
{
	Name (OBJ0, 0x1234)		// Number Object
	Name (OBJ1, "Hello")	// String Object

	Method (MAIN) {
		OBJ0 = 0x12345
		printf ("Hello World")
        RETURN (Zero)
	}
}

