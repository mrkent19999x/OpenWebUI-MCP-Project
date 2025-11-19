/**
 * Code Preview Component - Preview và tạo file TRONG OpenWebUI chat
 * Không cần terminal, chỉ cần chat panel
 */

class CodePreviewComponent {
  constructor() {
    this.previewMode = 'interactive'; // preview_only, auto_create, interactive
    this.supportedLanguages = ['python', 'javascript', 'typescript', 'json', 'markdown', 'html', 'css', 'yaml'];
  }

  /**
   * Tạo preview code block trong chat
   */
  createCodePreview(code, language = 'text', filename = null) {
    const container = document.createElement('div');
    container.className = 'code-preview-container';
    container.setAttribute('data-language', language);
    container.setAttribute('data-filename', filename || '');

    // Header với filename và language
    const header = document.createElement('div');
    header.className = 'code-preview-header';
    header.style.cssText = 'display: flex; justify-content: space-between; align-items: center; padding: 8px; background: #2d2d2d; border-radius: 8px 8px 0 0;';
    
    const title = document.createElement('span');
    title.style.cssText = 'color: #fff; font-size: 12px; font-weight: bold;';
    title.textContent = filename ? `📄 ${filename}` : `💻 ${language}`;
    header.appendChild(title);

    const languageBadge = document.createElement('span');
    languageBadge.style.cssText = 'background: #3b82f6; color: white; padding: 2px 8px; border-radius: 4px; font-size: 10px;';
    languageBadge.textContent = language.toUpperCase();
    header.appendChild(languageBadge);

    container.appendChild(header);

    // Code block
    const pre = document.createElement('pre');
    pre.style.cssText = 'margin: 0; padding: 12px; background: #1e1e1e; overflow-x: auto;';
    
    const codeElement = document.createElement('code');
    codeElement.className = `language-${language}`;
    codeElement.textContent = code;
    codeElement.style.cssText = 'color: #d4d4d4; font-family: "Fira Code", "Consolas", monospace; font-size: 13px; line-height: 1.5;';
    
    pre.appendChild(codeElement);
    container.appendChild(pre);

    // Actions
    const actions = document.createElement('div');
    actions.className = 'chat-actions';
    actions.style.cssText = 'display: flex; gap: 8px; padding: 8px; background: #2d2d2d; border-radius: 0 0 8px 8px;';

    // Copy button
    const copyBtn = document.createElement('button');
    copyBtn.className = 'btn-copy';
    copyBtn.textContent = '📋 Copy';
    copyBtn.style.cssText = 'padding: 6px 12px; background: #3b82f6; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 12px;';
    copyBtn.onclick = () => this.copyToClipboard(code);
    actions.appendChild(copyBtn);

    // Create file button (chỉ trong interactive mode)
    if (this.previewMode === 'interactive' && filename) {
      const createBtn = document.createElement('button');
      createBtn.className = 'btn-create-file';
      createBtn.textContent = '✅ Tạo File';
      createBtn.style.cssText = 'padding: 6px 12px; background: #10b981; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 12px;';
      createBtn.onclick = () => this.createFile(filename, code, language);
      actions.appendChild(createBtn);
    }

    container.appendChild(actions);

    return container;
  }

  /**
   * Tạo file tree preview
   */
  createFileTreePreview(files) {
    const container = document.createElement('div');
    container.className = 'file-tree-preview';
    container.style.cssText = 'background: #f5f5f5; border-radius: 8px; padding: 12px; margin: 8px 0; font-family: monospace; font-size: 12px; max-height: 300px; overflow-y: auto;';

    const tree = document.createElement('div');
    tree.className = 'file-tree';

    files.forEach(file => {
      const item = document.createElement('div');
      item.className = 'file-item';
      item.style.cssText = 'padding: 4px 8px; cursor: pointer;';
      
      if (file.isNew) {
        item.style.color = '#10b981';
        item.style.fontWeight = 'bold';
      }

      const icon = file.type === 'directory' ? '📁' : '📄';
      item.textContent = `${icon} ${file.path}`;
      
      item.onclick = () => {
        if (file.type === 'file') {
          this.showFilePreview(file.path, file.content);
        }
      };

      tree.appendChild(item);
    });

    container.appendChild(tree);
    return container;
  }

  /**
   * Copy code to clipboard
   */
  async copyToClipboard(text) {
    try {
      await navigator.clipboard.writeText(text);
      this.showNotification('✅ Đã copy code!');
    } catch (err) {
      console.error('Copy failed:', err);
      this.showNotification('❌ Copy thất bại');
    }
  }

  /**
   * Tạo file (gọi API)
   */
  async createFile(filename, content, language) {
    try {
      // Gọi API để tạo file
      const response = await fetch('/api/files/create', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          filename,
          content,
          language,
        }),
      });

      if (response.ok) {
        this.showNotification(`✅ Đã tạo file: ${filename}`);
        // Refresh file tree nếu có
        this.refreshFileTree();
      } else {
        throw new Error('Failed to create file');
      }
    } catch (error) {
      console.error('Create file error:', error);
      this.showNotification(`❌ Lỗi tạo file: ${error.message}`);
    }
  }

  /**
   * Show notification
   */
  showNotification(message, duration = 3000) {
    const toast = document.createElement('div');
    toast.className = 'notification-toast';
    toast.textContent = message;
    document.body.appendChild(toast);

    setTimeout(() => {
      toast.style.animation = 'slideOut 0.3s ease-out';
      setTimeout(() => toast.remove(), 300);
    }, duration);
  }

  /**
   * Refresh file tree
   */
  refreshFileTree() {
    // Trigger file tree refresh event
    window.dispatchEvent(new CustomEvent('fileTreeRefresh'));
  }

  /**
   * Show file preview
   */
  showFilePreview(filename, content) {
    const preview = this.createCodePreview(content, this.detectLanguage(filename), filename);
    // Insert vào chat
    const chatContainer = document.querySelector('.chat-container') || document.body;
    chatContainer.appendChild(preview);
  }

  /**
   * Detect language from filename
   */
  detectLanguage(filename) {
    const ext = filename.split('.').pop().toLowerCase();
    const langMap = {
      'py': 'python',
      'js': 'javascript',
      'ts': 'typescript',
      'json': 'json',
      'md': 'markdown',
      'html': 'html',
      'css': 'css',
      'yaml': 'yaml',
      'yml': 'yaml',
    };
    return langMap[ext] || 'text';
  }
}

// Export for use
if (typeof module !== 'undefined' && module.exports) {
  module.exports = CodePreviewComponent;
}

// Auto-initialize if in browser
if (typeof window !== 'undefined') {
  window.CodePreviewComponent = CodePreviewComponent;
  window.codePreview = new CodePreviewComponent();
}
