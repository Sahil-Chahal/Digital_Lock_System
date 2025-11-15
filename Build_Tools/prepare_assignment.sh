#!/bin/bash

# Script to prepare assignment document for Word conversion
# This creates a formatted version ready for docx conversion

echo "================================================"
echo "Digital Lock Assignment Document Preparation"
echo "================================================"
echo ""

# Check if pandoc is installed
if command -v pandoc &> /dev/null; then
    echo "✓ Pandoc found - Can convert to Word format"
    echo ""
    echo "Converting to Word document..."
    
    pandoc Assignment_Document.md \
        -o Digital_Lock_Assignment.docx \
        --toc \
        --toc-depth=3 \
        --number-sections \
        --highlight-style=tango \
        --reference-doc=reference.docx 2>/dev/null || \
    pandoc Assignment_Document.md \
        -o Digital_Lock_Assignment.docx \
        --toc \
        --toc-depth=3 \
        --number-sections \
        --highlight-style=tango
    
    if [ $? -eq 0 ]; then
        echo "✓ Word document created: Digital_Lock_Assignment.docx"
        echo ""
        ls -lh Digital_Lock_Assignment.docx
    else
        echo "✗ Error creating Word document"
    fi
else
    echo "⚠ Pandoc not installed"
    echo ""
    echo "Option 1: Install Pandoc (Recommended)"
    echo "  Ubuntu/Debian: sudo apt-get install pandoc"
    echo "  macOS: brew install pandoc"
    echo ""
    echo "Option 2: Manual conversion"
    echo "  1. Open Assignment_Document.md in VS Code"
    echo "  2. Copy all content"
    echo "  3. Open Microsoft Word"
    echo "  4. Paste and format manually"
    echo ""
    echo "Option 3: Use online converter"
    echo "  - Visit: https://cloudconvert.com/md-to-docx"
    echo "  - Upload Assignment_Document.md"
    echo "  - Download the .docx file"
    echo ""
fi

echo ""
echo "================================================"
echo "Document Information:"
echo "================================================"
echo "Source file: Assignment_Document.md"
echo "Size: $(wc -l < Assignment_Document.md) lines"
echo "Estimated pages: 25-30 pages (when formatted)"
echo ""
echo "Content includes:"
echo "  ✓ Complete project documentation"
echo "  ✓ Code explanations"
echo "  ✓ Block diagrams (ASCII format)"
echo "  ✓ State machine diagrams"
echo "  ✓ Test results"
echo "  ✓ References and appendices"
echo ""
echo "Next steps:"
echo "  1. Review Assignment_Document.md"
echo "  2. Convert to Word format"
echo "  3. Add college-specific details (name, logo, etc.)"
echo "  4. Format diagrams properly in Word"
echo "  5. Add your name and roll number"
echo "  6. Print and submit"
echo ""
echo "================================================"
