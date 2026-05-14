namespace Raylib.Bindings;

// TODO: Separate project. Raylib.Safe and automate the process
public static partial class Raylib
{
    public static unsafe void InitWindow(int width, int height, string title)
    {
        byte[] titleBytes = System.Text.Encoding.UTF8.GetBytes(title + "\0");
        fixed (byte* pTitle = titleBytes)
        {
            InitWindow(width, height, (sbyte*)pTitle);
        }
    }
}
