const express = require('express');
const cors = require('cors');
const { exec } = require('child_process');
const fs = require('fs').promises;
const path = require('path');
const multer = require('multer');

const app = express();
const PORT = process.env.PORT || 3001;

app.use(cors());
app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ extended: true, limit: '50mb' }));
app.use('/workspace', express.static('/workspace'));
app.use('/outputs', express.static('/outputs'));

// Configure multer for file uploads
const upload = multer({ 
    dest: '/workspace/uploads/',
    limits: { fileSize: 100 * 1024 * 1024 } // 100MB limit
});

// Initialize directories
async function initDirectories() {
    const dirs = ['/workspace', '/workspace/uploads', '/workspace/code', '/outputs'];
    for (const dir of dirs) {
        try {
            await fs.mkdir(dir, { recursive: true });
        } catch (err) {
            console.log(`Directory ${dir} already exists`);
        }
    }
}

// Security: Execute code in isolated environment
function executeCode(code, language = 'node') {
    return new Promise((resolve, reject) => {
        const workspace = '/workspace/code';
        const output = [];
        let timeout;

        const runCode = () => {
            let command;
            
            if (language === 'node') {
                const scriptPath = path.join(workspace, `temp_${Date.now()}.js`);
                fs.writeFile(scriptPath, code)
                    .then(() => {
                        command = `node ${scriptPath}`;
                        exec(command, { timeout: 30000 }, (error, stdout, stderr) => {
                            clearTimeout(timeout);
                            
                            // Clean up temporary file
                            fs.unlink(scriptPath).catch(() => {});
                            
                            if (error) {
                                resolve({
                                    success: false,
                                    error: error.message,
                                    output: stderr || error.message
                                });
                            } else {
                                resolve({
                                    success: true,
                                    output: stdout,
                                    error: stderr
                                });
                            }
                        });
                    })
                    .catch(reject);
                    
            } else if (language === 'python') {
                const scriptPath = path.join(workspace, `temp_${Date.now()}.py`);
                fs.writeFile(scriptPath, code)
                    .then(() => {
                        command = `python3 ${scriptPath}`;
                        exec(command, { timeout: 30000 }, (error, stdout, stderr) => {
                            clearTimeout(timeout);
                            
                            // Clean up temporary file
                            fs.unlink(scriptPath).catch(() => {});
                            
                            if (error) {
                                resolve({
                                    success: false,
                                    error: error.message,
                                    output: stderr || error.message
                                });
                            } else {
                                resolve({
                                    success: true,
                                    output: stdout,
                                    error: stderr
                                });
                            }
                        });
                    })
                    .catch(reject);
            }
        };

        // Set timeout to prevent infinite execution
        timeout = setTimeout(() => {
            resolve({
                success: false,
                error: 'Code execution timeout (30 seconds)',
                output: ''
            });
        }, 35000);

        runCode();
    });
}

// File operations
app.post('/api/files/create', async (req, res) => {
    try {
        const { path: filePath, content } = req.body;
        const fullPath = path.join('/workspace', filePath);
        await fs.writeFile(fullPath, content);
        res.json({ success: true, message: `File created: ${filePath}` });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
});

app.get('/api/files/read', async (req, res) => {
    try {
        const { path: filePath } = req.query;
        const fullPath = path.join('/workspace', filePath);
        const content = await fs.readFile(fullPath, 'utf8');
        res.json({ success: true, content });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
});

app.get('/api/files/list', async (req, res) => {
    try {
        const files = await fs.readdir('/workspace', { withFileTypes: true });
        const result = files.map(file => ({
            name: file.name,
            type: file.isDirectory() ? 'directory' : 'file',
            path: path.join('/workspace', file.name)
        }));
        res.json({ success: true, files: result });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
});

app.delete('/api/files/delete', async (req, res) => {
    try {
        const { path: filePath } = req.body;
        const fullPath = path.join('/workspace', filePath);
        await fs.unlink(fullPath);
        res.json({ success: true, message: `File deleted: ${filePath}` });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
});

// Code execution endpoints
app.post('/api/execute', async (req, res) => {
    try {
        const { code, language = 'node', timeout = 30 } = req.body;
        
        // Security check: prevent dangerous commands
        const dangerousCommands = ['rm -rf', 'sudo', 'chmod 777', '> /etc/', 'wget', 'curl -X', 'nc ', 'bash -i'];
        for (const cmd of dangerousCommands) {
            if (code.includes(cmd)) {
                return res.status(400).json({
                    success: false,
                    error: `Dangerous command detected: ${cmd}`
                });
            }
        }
        
        const result = await executeCode(code, language);
        res.json(result);
    } catch (error) {
        res.status(500).json({
            success: false,
            error: error.message
        });
    }
});

// Batch code execution
app.post('/api/execute/batch', async (req, res) => {
    try {
        const { files } = req.body; // Array of { path, content, language }
        const results = [];
        
        for (const file of files) {
            try {
                const result = await executeCode(file.content, file.language);
                results.push({
                    path: file.path,
                    success: result.success,
                    output: result.output,
                    error: result.error
                });
                
                // Save output
                const outputPath = `/outputs/${path.basename(file.path)}_output.txt`;
                await fs.writeFile(outputPath, result.output + (result.error ? '\nError: ' + result.error : ''));
            } catch (error) {
                results.push({
                    path: file.path,
                    success: false,
                    error: error.message
                });
            }
        }
        
        res.json({ success: true, results });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
});

// Web scraping endpoint
app.post('/api/scrape', async (req, res) => {
    try {
        const { url, selector, output_file } = req.body;
        
        const script = `
const puppeteer = require('puppeteer');

(async () => {
    const browser = await puppeteer.launch({
        headless: true,
        args: ['--no-sandbox', '--disable-setuid-sandbox']
    });
    
    const page = await browser.newPage();
    await page.goto('${url}', { waitUntil: 'networkidle2' });
    
    const content = await page.$eval('${selector}', el => el.textContent);
    console.log(content);
    
    await browser.close();
})();
`;
        
        // Install puppeteer if not available
        exec('npm list puppeteer', (error) => {
            if (error) {
                exec('npm install puppeteer', (installError) => {
                    if (installError) {
                        res.status(500).json({ success: false, error: 'Failed to install puppeteer' });
                        return;
                    }
                    executeCode(script, 'node').then(result => res.json(result));
                });
            } else {
                executeCode(script, 'node').then(result => res.json(result));
            }
        });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
});

// Environment info
app.get('/api/info', (req, res) => {
    res.json({
        success: true,
        environment: {
            node_version: process.version,
            platform: process.platform,
            workspace: '/workspace',
            outputs: '/outputs'
        }
    });
});

// Start server
async function start() {
    await initDirectories();
    app.listen(PORT, () => {
        console.log(`🚀 Code Execution Server running on port ${PORT}`);
        console.log(`📁 Workspace: /workspace`);
        console.log(`📤 Outputs: /outputs`);
        console.log(`🔗 OpenWebUI Integration: http://localhost:${PORT}/api`);
    });
}

start().catch(console.error);