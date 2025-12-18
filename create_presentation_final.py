#!/usr/bin/env python3
"""
Creates an ODP (OpenDocument Presentation) file for the memR project
Final version with embedded images
"""
import zipfile
import os
import shutil
from datetime import datetime

# Available images in the project
IMAGES = {
    'logic_gates': 'lissajous_logic_gates.png',
    'hardware_design': 'lissajous_hardware_design_frequency_multiplexing_demo.png'
}

# Presentation content
slides = [
    {
        "title": "tec-memR: Memristor Research Project",
        "content": [
            "Advanced Memristor Computing & Neural Networks",
            "Lissajous Phase-Based Hardware Implementation",
            "DIY Construction & Z80 Integration",
            "",
            "Presented by: Steve",
            f"Date: {datetime.now().strftime('%B %Y')}"
        ],
        "image": None
    },
    {
        "title": "What is a Memristor?",
        "content": [
            "• Passive two-terminal electronic component",
            "• Resistance changes based on voltage/current history",
            "• Acts as non-volatile memory element",
            "• Ideal for neuromorphic computing",
            "• Enables in-memory processing",
            "",
            "Key Property: 'Remembers' its last state without power"
        ],
        "image": None
    },
    {
        "title": "Project Components",
        "content": [
            "1. DIY Memristor Construction",
            "   - Copper-sulfide method",
            "   - Simple fabrication process",
            "",
            "2. Lissajous Phase Neural Networks",
            "   - Novel computing architecture",
            "   - Wave-based computation",
            "",
            "3. Hardware Integration",
            "   - Z80 microprocessor interface",
            "   - Crossbar array implementation"
        ],
        "image": None
    },
    {
        "title": "DIY Memristor: Copper-Sulfide Method",
        "content": [
            "Materials (Under $20):",
            "• Copper PCB or sheet",
            "• Sulfur powder",
            "• Isopropyl alcohol",
            "",
            "Process:",
            "1. Clean copper surface",
            "2. Apply sulfur slurry (12-24 hours)",
            "3. Form black copper sulfide layer",
            "4. Attach electrodes",
            "5. Test with pinched hysteresis loop"
        ],
        "image": None
    },
    {
        "title": "Lissajous Phase Neural Network",
        "content": [
            "Revolutionary Approach:",
            "• Uses phase relationships for computation",
            "• Frequency-division multiplexing (FDM)",
            "• Massive parallelism via wave superposition",
            "",
            "Key Advantage:",
            "Each wire can carry MANY parallel computations",
            "simultaneously at different frequencies",
            "",
            "Implemented logic gates: AND, OR, XOR, NAND"
        ],
        "image": 'logic_gates'
    },
    {
        "title": "Scaling Analysis: Frequency Multiplexing",
        "content": [
            "Technology     | Bandwidth  | Neurons Possible",
            "--------------------------------------------",
            "Analog (audio) | 100 kHz    | 1,000",
            "RF (wireless)  | 10 GHz     | 100,000,000",
            "Optical (fiber)| 100 THz    | 1,000,000,000,000",
            "",
            "MASSIVE parallelism through wave superposition!",
            "",
            "Current implementation: 4 neurons @ 1-4 kHz"
        ],
        "image": None
    },
    {
        "title": "Hardware Implementation Options",
        "content": [
            "1. FPGA (Fastest to prototype)",
            "   - ~1000 neurons @ 100 MHz",
            "   - Cost: ~$100 dev board",
            "",
            "2. Analog ASIC (Ultimate efficiency)",
            "   - 10,000 neurons in 5mm × 5mm chip",
            "   - 10 TOPS, only 10mW power",
            "",
            "3. Memristor Crossbar (Current focus!)",
            "   - Physical wave computation",
            "",
            "4. Photonic (Future work)",
            "   - Speed of light computation"
        ],
        "image": 'hardware_design'
    },
    {
        "title": "Memristor Crossbar Architecture",
        "content": [
            "KEY INSIGHT: Memristor state = Phase shift",
            "",
            "Architecture:",
            "• N×M crossbar array",
            "• AC voltage on rows (inputs)",
            "• Current summing on columns (outputs)",
            "• Each junction: learnable phase element",
            "",
            "Advantages:",
            "✓ Natural phase computation",
            "✓ No external phase shifters needed",
            "✓ Non-volatile (retains state)",
            "✓ Training via simple voltage pulses"
        ],
        "image": None
    },
    {
        "title": "Z80 Microprocessor Integration",
        "content": [
            "Hybrid Analog-Digital System:",
            "",
            "Z80 Role:",
            "• Controls DC programming pulses",
            "• Sets memristor states",
            "• Reads ADC outputs",
            "• Orchestrates computation",
            "",
            "Memristor Array:",
            "• Performs analog computation",
            "• Physical wave interference",
            "• Natural parallel processing"
        ],
        "image": None
    },
    {
        "title": "Current Achievements",
        "content": [
            "✓ Software simulation in Octave/MATLAB",
            "✓ Logic gates implementation (AND, OR, XOR, NAND)",
            "✓ Frequency multiplexing demonstration",
            "✓ Lissajous curve visualization",
            "✓ Hardware design documentation",
            "✓ Z80 assembly interface code",
            "",
            "Generated Visualizations:",
            "• Logic gate phase patterns",
            "• Frequency multiplexing spectrum",
            "• Hardware design diagrams"
        ],
        "image": None
    },
    {
        "title": "Implementation Roadmap",
        "content": [
            "Phase 1: Software Validation ✓",
            "  - Logic gates working in Octave",
            "",
            "Phase 2: Arduino Prototype",
            "  - Build 4-input neuron",
            "",
            "Phase 3: Memristor Integration",
            "  - 2×2 crossbar array",
            "  - Z80 interface",
            "",
            "Phase 4: FPGA Accelerator",
            "  - 100+ neuron scaling",
            "",
            "Phase 5: Publication & Open Source"
        ],
        "image": None
    },
    {
        "title": "Technical Innovations",
        "content": [
            "Novel Contributions:",
            "",
            "1. Phase-coded memristor computing",
            "   - Using AC impedance for computation",
            "",
            "2. Frequency-division neural multiplexing",
            "   - Massive parallelism in single wire",
            "",
            "3. DIY memristor fabrication",
            "   - Accessible, low-cost method",
            "",
            "4. Retro-computing integration",
            "   - Z80 + modern memristor tech"
        ],
        "image": None
    },
    {
        "title": "Applications",
        "content": [
            "Neuromorphic Computing:",
            "• Pattern recognition",
            "• Analog neural networks",
            "• In-memory computation",
            "",
            "Research & Education:",
            "• Physics demonstrations",
            "• DIY electronics projects",
            "• Academic publications",
            "",
            "Future Possibilities:",
            "• Edge AI acceleration",
            "• Ultra-low-power computing"
        ],
        "image": None
    },
    {
        "title": "Next Steps",
        "content": [
            "Immediate Goals:",
            "",
            "1. Build Arduino prototype (4-neuron demo)",
            "",
            "2. Fabricate 2×2 memristor crossbar",
            "",
            "3. Implement Z80 control interface",
            "",
            "4. Demonstrate XOR learning",
            "",
            "5. Document results for publication"
        ],
        "image": None
    },
    {
        "title": "Questions & Discussion",
        "content": [
            "",
            "",
            "Thank you!",
            "",
            "",
            "Project: tec-memR",
            "Memristor Research & Neural Computing",
            "",
            "",
            "Open for questions and collaboration"
        ],
        "image": None
    }
]

def create_odp():
    """Create proper ODP file structure with images"""

    # Check which images exist
    available_images = {}
    for key, filename in IMAGES.items():
        if os.path.exists(filename):
            available_images[key] = filename
            print(f"✓ Found image: {filename}")
        else:
            print(f"✗ Missing image: {filename}")

    # Create manifest with images
    manifest_files = '''<?xml version="1.0" encoding="UTF-8"?>
<manifest:manifest xmlns:manifest="urn:oasis:names:tc:opendocument:xmlns:manifest:1.0" manifest:version="1.2">
 <manifest:file-entry manifest:full-path="/" manifest:version="1.2" manifest:media-type="application/vnd.oasis.opendocument.presentation"/>
 <manifest:file-entry manifest:full-path="content.xml" manifest:media-type="text/xml"/>
 <manifest:file-entry manifest:full-path="styles.xml" manifest:media-type="text/xml"/>
 <manifest:file-entry manifest:full-path="meta.xml" manifest:media-type="text/xml"/>
 <manifest:file-entry manifest:full-path="settings.xml" manifest:media-type="text/xml"/>'''

    # Add image entries to manifest
    for key, filename in available_images.items():
        manifest_files += f'\n <manifest:file-entry manifest:full-path="Pictures/{filename}" manifest:media-type="image/png"/>'

    manifest_files += '\n</manifest:manifest>'

    # Create meta.xml
    meta = f'''<?xml version="1.0" encoding="UTF-8"?>
<office:document-meta xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
    xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0"
    xmlns:dc="http://purl.org/dc/elements/1.1/" office:version="1.2">
 <office:meta>
  <meta:generator>Python ODP Generator</meta:generator>
  <dc:title>tec-memR: Memristor Research Project</dc:title>
  <dc:creator>Steve</dc:creator>
  <dc:date>{datetime.now().isoformat()}</dc:date>
 </office:meta>
</office:document-meta>'''

    # Create settings.xml
    settings = '''<?xml version="1.0" encoding="UTF-8"?>
<office:document-settings xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" office:version="1.2">
 <office:settings/>
</office:document-settings>'''

    # Create styles.xml
    styles = '''<?xml version="1.0" encoding="UTF-8"?>
<office:document-styles xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
    xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0"
    xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
    xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0"
    xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0"
    xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0" office:version="1.2">
 <office:styles>
  <style:style style:name="Title" style:family="presentation">
   <style:text-properties fo:font-size="44pt" fo:font-weight="bold" fo:color="#003366"/>
  </style:style>
  <style:style style:name="Content" style:family="presentation">
   <style:text-properties fo:font-size="20pt" fo:color="#000000"/>
  </style:style>
 </office:styles>
 <office:automatic-styles>
  <style:page-layout style:name="PM1">
   <style:page-layout-properties fo:page-width="28cm" fo:page-height="21cm" style:print-orientation="landscape"/>
  </style:page-layout>
 </office:automatic-styles>
 <office:master-styles>
  <style:master-page style:name="Default" style:page-layout-name="PM1" draw:style-name="dp1"/>
 </office:master-styles>
</office:document-styles>'''

    # Build content.xml
    content_header = '''<?xml version="1.0" encoding="UTF-8"?>
<office:document-content xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
    xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0"
    xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
    xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0"
    xmlns:presentation="urn:oasis:names:tc:opendocument:xmlns:presentation:1.0"
    xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0" office:version="1.2">
 <office:automatic-styles>
  <style:style style:name="dp1" style:family="drawing-page"/>
  <style:style style:name="gr1" style:family="graphic">
   <style:graphic-properties draw:stroke="none" draw:fill="none"/>
  </style:style>
 </office:automatic-styles>
 <office:body>
  <office:presentation>'''

    slides_xml = ""
    for i, slide in enumerate(slides):
        title = slide["title"].replace('&', '&amp;').replace('<', '&lt;').replace('>', '&gt;')
        has_image = slide.get("image") and slide["image"] in available_images

        # Adjust content frame size if image is present
        content_height = "10cm" if has_image else "14cm"
        content_y = "5.5cm" if has_image else "5.5cm"

        slides_xml += f'''
   <draw:page draw:name="slide{i+1}" draw:master-page-name="Default" draw:style-name="dp1">
    <draw:frame presentation:style-name="pr1" draw:layer="layout" svg:width="24cm" svg:height="3cm" svg:x="2cm" svg:y="1.5cm" presentation:class="title">
     <draw:text-box>
      <text:p text:style-name="Title">{title}</text:p>
     </draw:text-box>
    </draw:frame>
    <draw:frame presentation:style-name="pr2" draw:layer="layout" svg:width="{"11cm" if has_image else "24cm"}" svg:height="{content_height}" svg:x="2cm" svg:y="{content_y}" presentation:class="outline">
     <draw:text-box>'''

        for line in slide["content"]:
            line_escaped = line.replace('&', '&amp;').replace('<', '&lt;').replace('>', '&gt;')
            if line_escaped.strip():
                slides_xml += f'''
      <text:p text:style-name="Content">{line_escaped}</text:p>'''
            else:
                slides_xml += '''
      <text:p text:style-name="Content"/>'''

        slides_xml += '''
     </draw:text-box>
    </draw:frame>'''

        # Add image if available
        if has_image:
            img_filename = available_images[slide["image"]]
            slides_xml += f'''
    <draw:frame draw:layer="layout" svg:width="12cm" svg:height="10cm" svg:x="14cm" svg:y="5.5cm">
     <draw:image xlink:href="Pictures/{img_filename}" xlink:type="simple" xlink:show="embed" xlink:actuate="onLoad"/>
    </draw:frame>'''

        slides_xml += '''
   </draw:page>'''

    content_footer = '''
  </office:presentation>
 </office:body>
</office:document-content>'''

    content = content_header + slides_xml + content_footer

    # Create ODP file
    odp_filename = "memR_presentation.odp"

    with zipfile.ZipFile(odp_filename, 'w', zipfile.ZIP_DEFLATED) as odp:
        # Add mimetype (must be first, uncompressed)
        odp.writestr('mimetype', 'application/vnd.oasis.opendocument.presentation', compress_type=zipfile.ZIP_STORED)
        # Add other files
        odp.writestr('META-INF/manifest.xml', manifest_files)
        odp.writestr('meta.xml', meta)
        odp.writestr('styles.xml', styles)
        odp.writestr('settings.xml', settings)
        odp.writestr('content.xml', content)

        # Add images
        for key, filename in available_images.items():
            with open(filename, 'rb') as img:
                odp.writestr(f'Pictures/{filename}', img.read())

    print(f"\n✓ Created: {odp_filename}")
    print(f"✓ Total slides: {len(slides)}")
    print(f"✓ Images embedded: {len(available_images)}")
    file_size = os.path.getsize(odp_filename)
    print(f"✓ File size: {file_size/1024:.1f} KB")
    return odp_filename

if __name__ == "__main__":
    create_odp()
