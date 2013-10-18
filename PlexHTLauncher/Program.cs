using System;
using System.Diagnostics;
using System.IO;
using System.Runtime.InteropServices;
using Microsoft.Win32;

namespace PlexHTLauncher
{
    static class Program
    {
        [DllImport("user32.dll")]
        private static extern bool SetForegroundWindow(IntPtr hWnd);

        [DllImport("user32.dll")]
        private static extern bool ShowWindow(IntPtr hWnd, int cmdShow);

        private const int SW_SHOWMAXIMIZED = 3;

        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        static void Main()
        {
            // Attempt to bring an existing PlexHT to the foreground.
            // If none exists, open PlexHT.
            if(!BringProcessToForeground())
                OpenPlexHT();               
        }

        private static bool BringProcessToForeground()
        {
            Process[] processes = Process.GetProcessesByName("Plex");
            if (processes.Length != 0)
            {
                // If PlexHT is currently running, bring it to the foreground
                IntPtr hWnd = processes[0].MainWindowHandle;
                ShowWindow(hWnd, SW_SHOWMAXIMIZED);
                SetForegroundWindow(hWnd);
                return true;
            }
            return false;
        }

        private static void OpenPlexHT()
        {
            string PlexHTPath = null;

            // Attempt to find the PlexHT executable location via the registry
            RegistryKey key = Registry.CurrentUser.OpenSubKey(@"Software\PlexHT");

            if (key != null) // If the path is in the registry use it to open PlexHT
            {
                PlexHTPath = key.GetValue("") as string;
                if (LaunchPlexHTProcess(PlexHTPath + @"\Plex.exe"))
                    return;
            }
            else // Otherwise, we'll try to use the default locations
            {
                string x86Path = @"C:\Program Files\Plex\Plex Media Center\Plex.exe";
                string x64Path = @"C:\Program Files (x86)\Plex\Plex Media Center\Plex.exe";

                if (LaunchPlexHTProcess(x86Path))
                    return;
                else
                    LaunchPlexHTProcess(x64Path);
            }           
        }

        private static bool LaunchPlexHTProcess(string path)
        {
            if (path != null && File.Exists(path))
            {
                string args = "";
                Process proc = new Process();

                if(File.Exists("PlexHTLaunchArgs.txt"))
                {
                    using (StreamReader argStream = File.OpenText("PlexHTLaunchArgs.txt"))
                    {
                        args = argStream.ReadLine();
                        argStream.Close();
                    }
                }
                       
                proc.StartInfo = new ProcessStartInfo(path, args);
                proc.Start();
                BringProcessToForeground();
                return true;
            }
            return false;
        }
    }
}