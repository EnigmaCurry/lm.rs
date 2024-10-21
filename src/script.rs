use std::env;
use std::fs::File;
use std::io::Write;
use std::path::PathBuf;

pub fn write_script_to_tempfile(
    script: &str,
    filename: &str,
) -> Result<PathBuf, Box<dyn std::error::Error>> {
    let mut temp_path = env::temp_dir();
    temp_path.push(filename);

    let mut temp_file = File::create(&temp_path)?;
    temp_file.write_all(script.as_bytes())?;

    // Make the script executable
    #[cfg(unix)]
    {
        use std::os::unix::fs::PermissionsExt;
        let mut perms = temp_file.metadata()?.permissions();
        perms.set_mode(0o755); // Make the file executable
        temp_file.set_permissions(perms)?;
    }

    Ok(temp_path)
}
